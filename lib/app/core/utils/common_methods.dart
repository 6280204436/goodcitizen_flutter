import '../../export.dart';
import '../widgets/intl_phone_field/countries.dart';

Country getSelectedCountryCode({String? code}) {
  if (code == null) {
    final index = countries.indexWhere(
            (item) => item.code == 'CA' && item.name.toLowerCase() == 'canada');
    if (index != -1) {
      return countries[index];
    }
    return countries.first;
  }

  dynamic dialCode;
  if (code.contains('+')) {
    dialCode = code.replaceAll('+', '').trim();
  } else {
    dialCode = code;
  }

  return countries.firstWhere((item) => item.dialCode == dialCode, orElse: () {
    final index = countries.indexWhere(
            (item) => item.code == 'CA' && item.name.toLowerCase() == 'canada');
    if (index != -1) {
      return countries[index];
    }
    return countries.first;
  });
}

String getFormattedContactNumber(
    {String? code, String? number, bool showPlus = true}) {
  return "${showPlus ? '+' : ''}${code ?? ''} ${number ?? ''}".trim();
}


Widget commonDividerWidget({double? height}) {
  return Divider(height:height?? margin_25, color: isDarkMode.value?AppColors.whiteLight:AppColors.appGreyColorDark);
}



getTextSinglePluralText({num? count, required String text}) {
  count ??= 0;
  return count > 1 ? '$count $text${keyS.tr}' : '$count $text';
}

Widget nextIconImage({Color? color,double? height,double? width}) {
  return AssetSVGWidget(icNextIcon,
      imageWidth:width?? height_12, imageHeight:height?? height_12,color: color,);
}

String formatToTwoDecimals(num? value) {
  if (value == null) {
    return '';
  }
  return value.toStringAsFixed(2) ?? '';



  if (value.toString().contains('.')) {
    List<String> parts = value.toString().split('.');

    if (parts[1].length > 2) {
      return '${parts[0]}.${parts[1].substring(0,2)}';
    }
  }
  return value.toString();
}