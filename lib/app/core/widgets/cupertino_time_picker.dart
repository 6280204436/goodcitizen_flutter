import 'package:good_citizen/app/core/values/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomSpinnerDateTimePicker extends StatefulWidget {
  const CustomSpinnerDateTimePicker({
    Key? key,
    required this.initialDateTime,
    required this.maximumDate,
    required this.minimumDate,
    this.use24hFormat = true,
    this.mode = CupertinoDatePickerMode.date,
    required this.didSetTime,
  }) : super(key: key);

  /// Callback called when set time button is tapped.
  final Function(DateTime) didSetTime;
  final DateTime initialDateTime;
  final DateTime maximumDate;
  final DateTime minimumDate;
  final bool use24hFormat;
  final CupertinoDatePickerMode mode;

  @override
  State<CustomSpinnerDateTimePicker> createState() => _SpinnerDateTimePickerState();
}

class _SpinnerDateTimePickerState extends State<CustomSpinnerDateTimePicker> {
  late DateTime initialDate;
  late DateTime maximumDate;
  late DateTime minimumDate;
  late DateTime selectedDateTime;

  void setupDateTime() {
    DateTime now = DateTime.now();
    now = widget.initialDateTime;

    initialDate = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );

    selectedDateTime = initialDate;

    var max = widget.maximumDate;
    maximumDate = DateTime(
      max.year,
      max.month,
      max.day,
      max.hour,
      max.minute,
    );

    var min = widget.minimumDate;
    minimumDate = DateTime(
      min.year,
      min.month,
      min.day,
      min.hour,
      min.minute,
    );
  }

  /// changes the button text based picker mode
  var buttonTitle = "SET DATE";

  /// check if mobile to change the scroll behavior based on mouse or touch
  bool isMobile = false;

  @override
  void initState() {
    super.initState();
    setupDateTime();

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      isMobile = true;
    }

    if (widget.mode == CupertinoDatePickerMode.date) {
      buttonTitle = "SET DATE";
    } else if (widget.mode == CupertinoDatePickerMode.time) {
      buttonTitle = "SET TIME";
    } else if (widget.mode == CupertinoDatePickerMode.dateAndTime) {
      buttonTitle = "SET DATE & TIME";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kIsWeb ? 320 : double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  child: ScrollConfiguration(
                    behavior: isMobile
                        ? const ScrollBehavior()
                        : const ScrollBehavior().copyWith(
                      dragDevices: {
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child:CupertinoTheme(
                      data:  CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(

                          dateTimePickerTextStyle: TextStyle(color: brownColor,fontWeight: FontWeight.w500  ),
                          primaryColor: Colors.transparent
                        ),
                      ),
                      child: CupertinoDatePicker(
                      initialDateTime: initialDate,
                      maximumDate: maximumDate,
                      minimumDate: minimumDate,
                      use24hFormat: widget.use24hFormat,
                      mode: widget.mode,

                      onDateTimeChanged: widget.didSetTime??(dateTime) {
                        selectedDateTime = dateTime;
                      },
                    ),
                  )),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
