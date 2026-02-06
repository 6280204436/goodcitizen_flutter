import '../../../export.dart';

class ExpiringTextView extends StatelessWidget {
  final int? date;
  final TextStyle? style;

  const ExpiringTextView({super.key, this.date, this.style});

  @override
  Widget build(BuildContext context) {
    return date==null?const SizedBox(): TextView(
        text: getText,
        textStyle: style ??
            textStyleTitleSmall()!.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.textGreyColorDark));
  }

  String get getText {
    final expiryDate = getDateFromMilliSec(date);

    if (expiryDate == null) {
      return '${keyExpiringOn.tr}: ${dateViewFormat(date: expiryDate)}';
    }
    final expiryDate1 =
        DateTime(expiryDate.year, expiryDate.month, expiryDate.day,0,0,0);
    final nowDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,0,0,0);


    if (expiryDate1.isAtSameMomentAs(nowDate)) {
      return keyExpiringToday.tr;
    } else if (nowDate.isAfter(expiryDate1)) {
      if (profileDataProvider.userDataModel.value?.docExpiryType == null) {
        return keyUnderVerify.tr;
      }
      return '${keyExpiredOn.tr}: ${dateViewFormat(date: expiryDate)}';
    } else {
      return '${keyExpiringOn.tr}: ${dateViewFormat(date: expiryDate)}';
    }
  }
}
