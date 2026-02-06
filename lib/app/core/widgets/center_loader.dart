import '../../export.dart';

Widget showCenterLoader({double? verticalPadding, Color? color}) {
  return Center(
          child: (Platform.isIOS
              ? CupertinoActivityIndicator(
                  color: color ?? (isDarkMode.value?Colors.white:AppColors.appColor),
                  radius: radius_12,
                )
              : CircularProgressIndicator(
                  color: color ?? (isDarkMode.value?Colors.white:AppColors.appColor),
                )))
      .paddingSymmetric(vertical: verticalPadding ?? margin_12);
}

Widget showCenterLoaderSmall({double? verticalPadding, Color? color}) {
  return Center(
          child: (Platform.isAndroid
              ? CupertinoActivityIndicator(
                  color: color ?? AppColors.appColor,
                  radius: radius_9,
                )
              : SizedBox(
                  height: height_15,
                  width: height_15,
                  child: CircularProgressIndicator(
                    color: color ?? AppColors.appColor,
                    strokeWidth: height_2,
                  ),
                )))
      .paddingSymmetric(vertical: verticalPadding ?? margin_12);
}
