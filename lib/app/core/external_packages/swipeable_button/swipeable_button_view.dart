import 'package:flutter/material.dart';
import 'package:good_citizen/app/core/values/app_values.dart';
import 'swipeable_widget.dart';


class SwipeableButtonView extends StatefulWidget {
  final VoidCallback onFinish;

  /// Event waiting for the process to finish
  final VoidCallback onWaitingProcess;

  /// Animation finish control
  final bool isFinished;
  final bool isLoading;
  final double? height;

  /// Button is active value default : true
  final bool isActive;

  /// Button active color value
  final Color activeColor;

  /// Button disable color value
  final Color? disableColor;

  /// Swipe button widget
  final Widget buttonWidget;

  /// Button color default : Colors.white
  final Color? buttonColor;

  /// Button center text
  final String buttonText;

  /// Button text style
  final TextStyle? buttontextstyle;

  /// Circle indicator color
  final Animation<Color?>? indicatorColor;
  const SwipeableButtonView(
      {Key? key,
      required this.onFinish,
      required this.onWaitingProcess,
      required this.activeColor,
      required this.buttonWidget,
      required this.buttonText,
      this.isFinished = false,
      this.isActive = true,
      this.isLoading = false,
      this.height ,
      this.disableColor = Colors.grey,
      this.buttonColor = Colors.white,
      this.buttontextstyle =
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      this.indicatorColor = const AlwaysStoppedAnimation<Color>(Colors.white)})
      : super(key: key);

  @override
  _SwipeableButtonViewState createState() => _SwipeableButtonViewState();
}

class _SwipeableButtonViewState extends State<SwipeableButtonView>
    with TickerProviderStateMixin {
  double opacity = 1;
  bool isFinishValue = false;
  bool isStartRippleEffect = false;
  late AnimationController _controller;

  bool isScaleFinished = false;

  late AnimationController rippleController;
  late AnimationController scaleController;

  late Animation<double> rippleAnimation;
  late Animation<double> scaleAnimation;



  init() {
    setState(() {
      opacity = 1;
      isFinishValue = false;
      isStartRippleEffect = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      isFinishValue = widget.isFinished;
    });

    rippleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                isFinishValue = true;
              });
              widget.onFinish();
            }
          });
    rippleAnimation =
        Tween<double>(begin: 60.0, end: 90.0).animate(rippleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              rippleController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              rippleController.forward();
            }
          });
    scaleAnimation =
        Tween<double>(begin: 1.0, end: 30.0).animate(scaleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                isScaleFinished = true;
              });
            }
          });

    //rippleController.forward();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {});
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    rippleController.dispose();
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(!widget.isLoading)
      {
        _controller.reset();
      }

    if (widget.isFinished) {
      setState(() {
        isStartRippleEffect = true;
        isFinishValue = true;
      });
      scaleController.forward();
    } else {
      if (isFinishValue) {
        scaleController.reverse().then((value) {
          init();
        });
      }
    }
    return Container(
      width: widget.isLoading
          ? (MediaQuery.of(context).size.width -
              ((MediaQuery.of(context).size.width - (widget.height??60)) * _controller.value))
          : double.infinity,
      height: (widget.height??60),
      decoration: BoxDecoration(
          color: widget.isActive ? widget.activeColor : widget.disableColor,
          borderRadius: BorderRadius.circular(30)),
      child: Stack(
        children: [
          Visibility(
            visible: !widget.isLoading,
            child: Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: 1,
                child: Text(
                  widget.buttonText,
                  style: widget.buttontextstyle,
                ),
              ),
            ),
          ),
          !widget.isLoading
              ? SwipeableWidget(
                  isActive: widget.isActive,
                  height:(widget.height??60),
                  onSwipeValueCallback: (value) {
                    setState(() {
                      opacity = value;
                    });
                  },
                  child: Container(
                    height: (widget.height??60),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Material(
                            elevation: 2,
                            shape: CircleBorder(),
                            child: Container(
                              width: (widget.height??60)-height_4,
                              height: (widget.height??60)-height_4,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.buttonColor),
                              child: Center(
                                child: widget.buttonWidget,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onSwipeCallback: ()async {
                    widget.onWaitingProcess();
                 await   _controller.animateTo(1.0,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.fastOutSlowIn);
                 setState(() {
                   opacity=1;
                 });
                  },
                )
              : AnimatedBuilder(
                  animation: rippleAnimation,
                  builder: (context, child) => Container(
                    width: rippleAnimation.value,
                    height: rippleAnimation.value,
                    child: AnimatedBuilder(
                        animation: scaleAnimation,
                        builder: (context, child) => Transform.scale(
                              scale: scaleAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.activeColor.withOpacity(0.4),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(height_10),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: widget.isActive
                                              ? widget.activeColor
                                              : widget.disableColor),
                                      child: Center(
                                        child: !isFinishValue
                                            ? CircularProgressIndicator(
                                                valueColor:
                                                    widget.indicatorColor,strokeWidth: height_2,)
                                            : const SizedBox(),
                                      )),
                                ),
                              ),
                            )),
                  ),
                )
        ],
      ),
    );
  }
}
