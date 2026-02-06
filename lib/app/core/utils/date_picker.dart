
import '../../export.dart';

Future<DateTime?> showDatePickerWidget(
    {String? title,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    bool setInitial = true}) async {
  DateTime? selected;
  final now = DateTime.now();
  if (firstDate != null && firstDate.isBefore(now) && setInitial) {
    firstDate = now;
    if (initialDate != null && initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    }
  }

  if (firstDate != null && lastDate != null) {
    // if(firstDate.isAfter(now) && lastDate.isAfter(now))
    //   {
    //     lastDate=now;
    //   }

    if ((lastDate.isBefore(firstDate))) {
      lastDate = firstDate;
    }
  }

  initialDate ??= lastDate;
  initialDate ??= firstDate;

  if (Platform.isIOS) {
    selected=initialDate;
    await showModalBottomSheet(
      context: Get.context!,

      builder: (BuildContext builder) {
        // Create the modal bottom sheet widget containing the time picker and close button
        return SizedBox(
          height: Get.height / 3,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: TextView(
                      text: keyDone,
                      textStyle: textStyleTitleMedium()
                          !.copyWith(fontWeight: FontWeight.w600))
                      .paddingOnly(top: margin_15, right: margin_20),
                ),
              ),
              // Time picker,
              Expanded(
                child: CupertinoDatePicker(
                  minimumDate: firstDate,
                  maximumDate: lastDate,

                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate,
                  onDateTimeChanged: (newTime) {
                    selected = newTime;
                  },
                ),
              ),

              // Close button
            ],
          ),
        );
      },
    );
  } else {
    selected = await showDatePicker(
        context: Get.context!,
        helpText: keySelectDate.tr,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate ?? DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.appColor,
                onPrimary: AppColors.whiteAppColor,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.appColor, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        lastDate: lastDate ?? DateTime(DateTime
            .now()
            .year + 50));
  }

  return selected;
}

Future<DateTime?> showTimePickerWidget({
  String? title,
  DateTime? initialTime,
}) async {



  DateTime? selected;

  if (Platform.isIOS) {
   await showModalBottomSheet(
      context: Get.context!,
      builder: (BuildContext builder) {
        // Create the modal bottom sheet widget containing the time picker and close button
        return SizedBox(
          height: Get.height / 3,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: TextView(
                          text: keyDone,
                          textStyle: textStyleTitleMedium()
                              !.copyWith(fontWeight: FontWeight.w600))
                      .paddingOnly(top: margin_15, right: margin_20),
                ),
              ),
              // Time picker,
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: initialTime,
                  onDateTimeChanged: (newTime) {
                    selected = newTime;
                  },
                ),
              ),

              // Close button
            ],
          ),
        );
      },
    );
  } else {
    TimeOfDay? selectedTime = await showTimePicker(
        context: Get.context!,
        helpText: title,
        initialEntryMode: TimePickerEntryMode.dialOnly,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                  primary: AppColors.appColor,
                  onSurface: AppColors.appColor,
                  secondary: AppColors.appColor,
                  onSecondary: AppColors.whiteAppColor),
              buttonTheme: const ButtonThemeData(
                colorScheme: ColorScheme.light(
                  primary: AppColors.appColor,
                ),
              ),
            ),
            child: child!,
          );
        },
        initialTime: initialTime != null
            ? TimeOfDay(hour: initialTime.hour, minute: initialTime.minute)
            : TimeOfDay.now());

    if (selectedTime != null) {
      selected = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, selectedTime.hour, selectedTime.minute);
    }
  }

  return selected;
}

bool isValidTime({String? startTime, String? endTime}) {
  if (startTime == null || endTime == null) {
    return true;
  }

  final current = DateTime.now();
  final startInDate = DateTime.parse(startTime);
  final endInDate = DateTime.parse(endTime);
  final start = DateTime(current.year, current.month, current.day,
      startInDate.hour, startInDate.minute);
  final end = DateTime(current.year, current.month, current.day, endInDate.hour,
      endInDate.minute);

  if (start.isAfter(end) ||
      end.isBefore(start) ||
      start.isAtSameMomentAs(end)) {
    return false;
  }
  return true;
}
