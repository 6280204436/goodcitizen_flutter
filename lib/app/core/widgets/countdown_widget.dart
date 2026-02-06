import 'package:good_citizen/app/core/widgets/text_view_widget.dart';

import '../../export.dart';

class CountDownWidget extends StatefulWidget {
  final DateTime? time;
  final TextStyle? textStyle;

  const CountDownWidget({super.key, this.time, this.textStyle});

  @override
  State<CountDownWidget> createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {
  late Duration timerDuration;
  late Timer timer;
  int sec = 0;

  @override
  void initState() {
    final startTimer = widget.time;
    final currentTime = DateTime.now();
    if (startTimer == null ||
        currentTime.isAtSameMomentAs(startTimer) ||
        currentTime.isAfter(startTimer)) {
      timerDuration = const Duration();
    } else {
      final difference = startTimer.difference(currentTime);
      timerDuration = difference;
    }

    _startTimer();
    super.initState();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      timer = t;
      sec = timerDuration.inSeconds;
      if (sec > 0) {
        sec -= 1;
        timerDuration = Duration(seconds: sec);
        if (mounted) {
          setState(() {});
        }
      } else {
        timer.cancel();
      }
    });
  }

  String get _formattedDuration {
    // var seconds = timerDuration.inSeconds;
    // final days = seconds ~/ Duration.secondsPerDay;
    // seconds -= days * Duration.secondsPerDay;
    // final hours = seconds ~/ Duration.secondsPerHour;
    // seconds -= hours * Duration.secondsPerHour;
    // final minutes = seconds ~/ Duration.secondsPerMinute;
    // seconds -= minutes * Duration.secondsPerMinute;
    //
    // final List<String> tokens = [];
    //
    // tokens.add('$days${days>1?strDays:strDay}');
    //
    // if (tokens.isNotEmpty || hours != 0) {
    //   tokens.add('$hours${hours>1?strHrs:strHr}');
    // }
    // if (tokens.isNotEmpty || minutes != 0) {
    //   tokens.add('$minutes$strMin');
    // }
    // tokens.add('$seconds$strSec');

    // return tokens.join(' : ');
    return '';
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextView(
      text: _formattedDuration,
      textAlign: TextAlign.start,
      textStyle: widget.textStyle ??
          textStyleTitleSmall()!.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
      maxLines: 2,
    );
  }
}
