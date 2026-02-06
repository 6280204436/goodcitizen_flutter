import '../../export.dart';

void showCommonBottomSheet(
    {bool isDismissible = true,
    double? height,
    double? width,
    double? topRadius,
    Color? barrierColor,
    Widget? child,
    bool isScrollControlled = false,
    bool showHeaderContainer = true,
    VoidCallback? onHideSheet}) async {
  await Get.bottomSheet(
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      isScrollControlled: isScrollControlled,
      barrierColor: barrierColor,
      Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: isDarkMode.value?Colors.black:whiteAppColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topRadius ?? radius_22),
              topRight: Radius.circular(topRadius ?? radius_22),
            )),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              color: isDarkMode.value?AppColors.whiteLight:whiteAppColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(topRadius ?? radius_22),
                topRight: Radius.circular(topRadius ?? radius_22),
              )),
          child: SafeArea(
            child: Column(
              children: [
                Visibility(
                    visible: showHeaderContainer,
                    child: sheetBarContainer()
                        .paddingOnly(top: margin_3, bottom: margin_14)),
                Expanded(child: child ?? const SizedBox())
              ],
            ).paddingSymmetric(horizontal: margin_18, vertical: margin_8),
          ),
        ),
      ));
  onHideSheet?.call();
}

Widget sheetBarContainer() {
  return Container(
      height: height_4,
      width: height_60,
      decoration: BoxDecoration(
          color: AppColors.textGreyColor,
          borderRadius: BorderRadius.circular(radius_15)));
}


void showNewBottomSheet(
    {bool isDismissible = true,
      double? maxHeight,
      double? width,
      double? topRadius,
      Widget? child,
      Color? barrierColor,
      bool showVerticalPadding = true,
      bool showCrossIcon = true,
      bool isScrollControlled = true,
      bool addScrollView = true,
      bool includeSafeArea = true,
      bool showHeaderContainer = false,
      VoidCallback? onHideSheet})async {
  await Get.bottomSheet(
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      Container(
        width: width,
        constraints:
        maxHeight != null ? BoxConstraints(maxHeight: maxHeight) : null,
        decoration: BoxDecoration(
            color: isDarkMode.value?AppColors.blackColor:AppColors.whiteAppColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topRadius ?? radius_22),
              topRight: Radius.circular(topRadius ?? radius_22),
            )),
        child: Container(decoration: BoxDecoration(
            color: isDarkMode.value?AppColors.whiteLight:AppColors.whiteAppColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topRadius ?? radius_22),
              topRight: Radius.circular(topRadius ?? radius_22),
            )),
          child: SafeArea(
              top: includeSafeArea,
              bottom: includeSafeArea,
              child: child ?? const SizedBox()),
        ),
      ));
  onHideSheet?.call();
}
