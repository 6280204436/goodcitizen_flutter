import 'package:good_citizen/app/core/widgets/text_view_widget.dart';

import '../../export.dart';



showSnackBar(
    {required String message, Color? bgColor, bool isWarning = false,int? seconds}) {
  if (isWarning) {
    bgColor = redColor;
  }
  Get.closeAllSnackbars();
  return Get.snackbar(keyAppName.tr, message.tr,
      titleText: TextView(text: strAppName, textStyle: textStyleTitleLarge()!),
      duration:  Duration(seconds:seconds?? 2),

      backgroundGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: bgColor != null
            ? [bgColor.withOpacity(0.5), bgColor]
            : [
          AppColors.appColor.withOpacity(0.5),
          AppColors.appColor,
        ],
      ));
}

