

import '../../export.dart';

class DoubleBack extends StatefulWidget {
  final Widget child;
  final int waitForSecondBackPress;
  final Function? onFirstBackPress;
  final bool condition;
  final VoidCallback? onConditionFail;
  final TextStyle textStyle;
  final Color background;
  final double backgroundRadius;

  /// DoubleBack, wrap a widget to use it
  const DoubleBack({
    Key? key,
    required this.child,
    this.waitForSecondBackPress = 2,
    this.onFirstBackPress,
    this.condition = true,
    this.onConditionFail,
    this.textStyle = const TextStyle(fontSize: 14, color: Colors.white),
    this.background = const Color(0xAA000000),
    this.backgroundRadius = 20,
  }) : super(key: key);

  @override
  _DoubleBackState createState() => _DoubleBackState();
}

class _DoubleBackState extends State<DoubleBack> {
  bool tapped = false;

  bool get _isAndroid => Theme.of(context).platform == TargetPlatform.android;

  @override
  Widget build(BuildContext context) {
    if (_isAndroid) {
      return WillPopScope(
        onWillPop: () async {


          if (widget.condition) {
            if (tapped) {
              return true;
            } else {
              tapped = true;
              Timer(
                Duration(
                  seconds: widget.waitForSecondBackPress,
                ),
                resetBackTimeout,
              );

              if (widget.onFirstBackPress != null) {
                widget.onFirstBackPress!(context);
              } else {
                showSnackBar(message: keyPressAgain.tr);
              }

              return false;
            }
          } else {
            if (widget.onConditionFail != null) {
              widget.onConditionFail!();
            }
            return false;
          }
        },
        child: widget.child,
      );
    }
else {
  return widget.child;
    }
    // else {
    //   return GestureDetector(
    //       onHorizontalDragEnd: (details) {
    //         if (details.velocity.pixelsPerSecond.dx > 50) {
    //           if (Get.currentRoute == AppRoutes.mainScreenRoute) {
    //             final mainController = Get.find<MainScreenController>();
    //
    //             if (mainController.selectedDrawerIndex.value != 0) {
    //               mainController.changeDrawerIndex(0);
    //             }
    //           }
    //         }
    //       },
    //       child: widget.child); widget.child;
    // }
  }

  void resetBackTimeout() {
    tapped = false;
  }
}
