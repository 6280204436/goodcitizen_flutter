import 'package:intl/intl.dart' hide TextDirection;

import '../../export.dart';

class DecoratedInputBorder extends InputBorder {
  DecoratedInputBorder({
    required this.child,
    required this.shadow,
  }) : super(borderSide: child.borderSide);

  final InputBorder child;

  final BoxShadow? shadow;

  @override
  bool get isOutline => child.isOutline;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      child.getInnerPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      child.getOuterPath(rect, textDirection: textDirection);

  @override
  EdgeInsetsGeometry get dimensions => child.dimensions;

  @override
  InputBorder copyWith(
      {BorderSide? borderSide,
        InputBorder? child,
        BoxShadow? shadow,
        bool? isOutline}) {
    return DecoratedInputBorder(
      child: (child ?? this.child).copyWith(borderSide: borderSide),
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  ShapeBorder scale(double t) {
    final scalledChild = child.scale(t);

    return DecoratedInputBorder(
      child: scalledChild is InputBorder ? scalledChild : child,
      shadow: BoxShadow.lerp(null, shadow, t),
    );
  }

  @override
  void paint(Canvas canvas, Rect rect,
      {double? gapStart,
        double gapExtent = 0.0,
        double gapPercentage = 0.0,
        TextDirection? textDirection}) {
    final clipPath = Path()
      ..addRect(const Rect.fromLTWH(-5000, -5000, 10000, 10000))
      ..addPath(getInnerPath(rect), Offset.zero)
      ..fillType = PathFillType.evenOdd;
    canvas.clipPath(clipPath);

    final Paint paint = shadow!.toPaint();
    final Rect bounds =
    rect.shift(shadow!.offset).inflate(shadow!.spreadRadius);

    canvas.drawPath(getOuterPath(bounds), paint);

    child.paint(canvas, rect,
        gapStart: gapStart,
        gapExtent: gapExtent,
        gapPercentage: gapPercentage,
        textDirection: textDirection);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is DecoratedInputBorder &&
        other.borderSide == borderSide &&
        other.child == child &&
        other.shadow == shadow;
  }

  @override
  int get hashCode => Object.hash(borderSide, child, shadow);
}

String dateFormat({DateTime? date}) {
  if (date == null) {
    return '';
  }

  var outputFormat = DateFormat('dd MMM yyyy');
  var outputDate = outputFormat.format(date);
  return outputDate;
}

String dateFormatString({DateTime? date}) {
  if (date == null) {
    return '';
  }

  var outputFormat = DateFormat('dd MMM yyyy');
  var outputDate = outputFormat.format(date);
  return outputDate;
}

String dateTimeFormat({DateTime? date, String? stringDate}) {
  if (date == null && stringDate == null) {
    return '';
  }
  if (stringDate != null) {
    date = DateTime.parse(stringDate);
  }

  var outputFormat = DateFormat('dd MMM yyyy, h:mm a');
  var outputDate = outputFormat.format(date ?? DateTime.now());
  return outputDate;
}

String dateViewFormatShort({DateTime? date, String? stringDate}) {
  if (date == null && stringDate == null) {
    return '';
  }
  if (stringDate != null) {
    date = DateTime.parse(stringDate);
  }

  var outputFormat = DateFormat('dd MMM yy');
  var outputDate = outputFormat.format(date ?? DateTime.now());
  return outputDate;
}

String dateViewFormatLong({DateTime? date, String? stringDate}) {
  if (date == null && stringDate == null) {
    return '';
  }
  if (stringDate != null) {
    date = DateTime.parse(stringDate);
  }

  var outputFormat = DateFormat('EEE, dd MMM yyyy hh:mm a');
  var outputDate = outputFormat.format(date ?? DateTime.now());
  return outputDate;
}

String dayMonthFormat({DateTime? date, String? stringDate}) {
  if (date == null && stringDate == null) {
    return '';
  }
  if (stringDate != null) {
    date = DateTime.parse(stringDate);
  }

  var outputFormat = DateFormat('dd MMM');
  var outputDate = outputFormat.format(date ?? DateTime.now());
  return outputDate;
}

String dateViewFormat({DateTime? date, String? stringDate}) {
  if (date == null && stringDate == null) {
    return '';
  }
  if (stringDate != null) {
    date = DateTime.parse(stringDate);
  }

  var outputFormat = DateFormat('dd MMM yyyy');
  var outputDate = outputFormat.format(date ?? DateTime.now());
  return outputDate;
}

String rideDateTimeFormat({DateTime? date, String? stringDate}) {
  if (date == null && stringDate == null) {
    return '';
  }
  if (stringDate != null) {
    date = DateTime.parse(stringDate);
  }

  var outputFormat = DateFormat('dd MMM yyyy / hh:mm a');
  var outputDate = outputFormat.format(date ?? DateTime.now());
  return outputDate;
}

String rideTimeFormat({DateTime? date, String? stringDate}) {
  if (date == null && stringDate == null) {
    return '';
  }
  if (stringDate != null) {
    date = DateTime.parse(stringDate);
  }

  var outputFormat = DateFormat('hh:mm a');
  var outputDate = outputFormat.format(date ?? DateTime.now());
  return outputDate;
}

String dateViewFormat2({DateTime? date, String? stringDate}) {
  if (date == null && stringDate == null) {
    return '';
  }
  if (stringDate != null) {
    date = DateTime.parse(stringDate);
  }

  var outputFormat = DateFormat('dd MMM yyyy');
  var outputDate = outputFormat.format(date ?? DateTime.now());
  return outputDate;
}

String monthYearFormat({DateTime? date, String? stringDate}) {
  if (date == null && stringDate == null) {
    return '';
  }
  if (stringDate != null) {
    date = DateTime.parse(stringDate);
  }

  var outputFormat = DateFormat('MMMM yyyy');
  var outputDate = outputFormat.format(date ?? DateTime.now());
  return outputDate;
}

String dateWeekDayFormat({DateTime? date, String? stringDate}) {
  if (date == null && stringDate == null) {
    return '';
  }
  if (stringDate != null) {
    date = DateTime.parse(stringDate);
  }

  var outputFormat = DateFormat('EEE, dd MMM yyyy');
  var outputDate = outputFormat.format(date ?? DateTime.now());
  return outputDate;
}

String dateMonthFormat({DateTime? date}) {
  if (date == null) {
    return '';
  }

  var outputFormat = DateFormat('MMMM, yyyy');
  var outputDate = outputFormat.format(date);
  return outputDate;
}

String timeFormat({DateTime? date, String? stringDate}) {
  if (date == null && stringDate == null) {
    return '';
  }
  if (stringDate != null) {
    date = DateTime.parse(stringDate);
  }
  var outputFormat = DateFormat('hh:mm a');
  var outputDate = outputFormat.format(date ?? DateTime.now());
  return outputDate;
}

bool isDateExpired(DateTime? date) {
  if (date == null) {
    return false;
  }

  return date.isBefore(DateTime.now());
}

DateTime? getDateFromMilliSec(int? milliSec) {
  if (milliSec == null) {
    return null;
  }
  return DateTime.fromMillisecondsSinceEpoch(
    milliSec,
  );
}

String getTimeDuration(DateTime? start, DateTime? end) {
  if (start == null || end == null) {
    return '';
  }

  Duration duration = end.difference(start);

  int days = duration.inDays;
  int hours = duration.inHours.remainder(24);
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  String daysStr = days > 0 ? '$days ${keyDay.tr.toLowerCase()}${days > 1 ? '' : ''} ' : '';
  String hoursStr = hours > 0 ? '$hours ${keyHour.tr.toLowerCase()}${hours > 1 ? '' : ''} ' : '';
  String minutesStr =
  minutes > 0 ? '$minutes ${keyMin.tr.toLowerCase()}${minutes > 1 ? '' : ''} ' : '';
  String secondsStr =
  seconds > 0 ? '$seconds ${keySec.tr.toLowerCase()}${seconds > 1 ? '' : ''} ' : '';

  return '$daysStr$hoursStr$minutesStr$secondsStr'.trim();
}

String timeAgoFromDateTime(DateTime? dt) {
  if (dt == null) {
    return '';
  }

  DateTime now = DateTime.now();
  Duration difference = now.difference(dt);

  int seconds = difference.inSeconds;
  int days = difference.inDays;

  int years = (days / 365).floor();
  int weeks = (days / 7).floor();
  int months = (days / 30).floor();
  int hours = (seconds / 3600).floor();
  int minutes = ((seconds % 3600) / 60).floor();

  if (years > 0) {
    return "$years year${years > 1 ? 's' : ''} ago";
  } else if (months > 0) {
    return "$months month${months > 1 ? 's' : ''} ago";
  } else if (weeks > 0) {
    return "$weeks week${weeks > 1 ? 's' : ''} ago";
  } else if (days > 0) {
    return "$days day${days > 1 ? 's' : ''} ago";
  } else if (hours > 0) {
    return "$hours hour${hours > 1 ? 's' : ''} ago";
  } else if (minutes > 0) {
    return "$minutes minute${minutes > 1 ? 's' : ''} ago";
  } else {
    return "Just now";
  }
}

String getWeekdayName(DateTime dateTime) {
  int weekday = dateTime.weekday;

  switch (weekday) {
    case 1:
      return 'monday';
    case 2:
      return 'tuesday';
    case 3:
      return 'wednesday';
    case 4:
      return 'thursday';
    case 5:
      return 'friday';
    case 6:
      return 'saturday';
    case 7:
      return 'sunday';
    default:
      return 'error: invalid weekday';
  }
}