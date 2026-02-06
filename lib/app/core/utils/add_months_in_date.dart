import 'dart:core';

DateTime? addMonthsInDate(DateTime? date, int monthsToAdd) {
  if (date == null) {
    return date;
  }

  final newMonth = date.month + monthsToAdd;
  final yearOffset = newMonth ~/ 12;
  final monthOffset = newMonth % 12;
  final newYear = date.year + yearOffset;
  final newDay = date.day.clamp(1, _daysInMonth(newYear, monthOffset));
  return DateTime(newYear, monthOffset, newDay, date.hour, date.minute,
      date.second, date.millisecond, date.microsecond);
}

int _daysInMonth(int year, int month) {
  if (month == 2) {
    if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
      return 29;
    } else {
      return 28;
    }
  } else {
    if ([1, 3, 5, 7, 8, 10, 12].contains(month)) {
      return 31;
    } else {
      return 30;
    }
  }
}
