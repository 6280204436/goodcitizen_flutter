import 'dart:ui';

import 'package:good_citizen/app/core/widgets/network_image_widget.dart';
import 'package:good_citizen/app/core/widgets/text_view_widget.dart';
import 'package:good_citizen/app/export.dart';

void showAlertDialog(
    {required String title,
    String? subtitle,
    Widget? subtitleWidget,
    String? imagePath,
    bool showButton = true,
    String? buttonText,
    VoidCallback? onTap}) {
  Get.generalDialog(
      barrierColor: Colors.black.withOpacity(0.15),
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInSine.transform(a1.value);
        return Transform.scale(
            scale: curve,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: margin_15),
                      decoration: BoxDecoration(
                          color: isDarkMode.value ? Colors.black : whiteColor,
                          borderRadius: BorderRadius.circular(radius_10)),
                      child: Container(
                        decoration: BoxDecoration(
                            color: isDarkMode.value
                                ? AppColors.whiteLight
                                : whiteColor,
                            borderRadius: BorderRadius.circular(radius_10)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: AssetSVGWidget(icRemoveIcon,
                                            imageHeight: height_19)))
                                .paddingOnly(bottom: margin_3),
                            TextView(
                              text: title,
                              textStyle: textStyleHeadlineMedium()!
                                  .copyWith(fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ).paddingOnly(bottom: margin_10),
                            (subtitleWidget ??
                                    TextView(
                                      text: subtitle ?? '',
                                      textStyle: textStyleTitleMedium()!
                                          .copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: darkGreyColor),
                                      textAlign: TextAlign.center,
                                      maxLines: 8,
                                    ))
                                .paddingOnly(bottom: margin_14),
                            showButton
                                ? CustomMaterialButton(
                                    onTap: onTap ??
                                        () {
                                          Get.back();
                                        },
                                    buttonHeight: height_38,
                                    buttonText: buttonText ?? keyOK.tr,
                                  )
                                : const SizedBox()
                          ],
                        ).paddingSymmetric(
                            horizontal: margin_18, vertical: margin_15),
                      )),
                ]));
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: true,
      barrierLabel: '');
}

Future showAlertDialogNew(
    {required String title,
    String? subtitle,
    Widget? subtitleWidget,
    String? imagePath,
    bool showButton = true,
    String? buttonText,
    VoidCallback? onTap}) async {
  await Get.generalDialog(
      barrierColor: Colors.black.withOpacity(0.15),
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInSine.transform(a1.value);
        return Transform.scale(
            scale: curve,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: margin_30),
                      decoration: BoxDecoration(
                          color: isDarkMode.value
                              ? Colors.black
                              : AppColors.whiteAppColor,
                          borderRadius: BorderRadius.circular(margin_5)),
                      child: Container(
                        decoration: BoxDecoration(
                            color: isDarkMode.value
                                ? AppColors.whiteLight
                                : AppColors.whiteAppColor,
                            borderRadius: BorderRadius.circular(margin_5)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            imagePath != null
                                ? AssetImageWidget(
                                    imagePath,
                                    imageWidth: height_75,
                                    imageHeight: height_75,
                                  ).paddingOnly(bottom: margin_15)
                                : const SizedBox(),
                            TextView(
                              text: title,
                              textStyle: textStyleHeadlineMedium()!
                                  .copyWith(fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                            ).paddingOnly(bottom: margin_10),
                            (subtitleWidget ??
                                    TextView(
                                      text: subtitle ?? '',
                                      textStyle: textStyleTitleMedium()!
                                          .copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.darkGreyColor),
                                      textAlign: TextAlign.center,
                                      maxLines: 10,
                                    ))
                                .paddingOnly(bottom: margin_10),
                            showButton
                                ? CustomMaterialButton(
                                    onTap: onTap ??
                                        () {
                                          Get.back();
                                        },
                                    buttonHeight: height_35,
                                    borderRadius: radius_4,
                                    buttonText: buttonText ?? 'OK',
                                  )
                                : const SizedBox()
                          ],
                        ).paddingSymmetric(
                            horizontal: margin_15, vertical: margin_10),
                      )),
                ]));
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: true,
      barrierLabel: '');
}

void showImageDialog(
    {String? imagePath,
    String? text,
    bool isNetwork = true,
    bool includeBaseUrl = true,
    String? placeHolder,
    double? height,
    double? width}) {
  if (imagePath == null || imagePath == '') {
    return;
  }

  Get.generalDialog(
    barrierColor: Colors.black.withOpacity(0.15),
    pageBuilder: (ctx, a1, a2) {
      return Container();
    },
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.easeInSine.transform(a1.value);

      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: FadeTransition(
          opacity: a1,
          child: Stack(
            alignment: Alignment.topRight,
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: Get.width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height ?? height_300,
                      width: width ?? height_250,
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          InteractiveViewer(
                            panEnabled: false,
                            minScale: 0.5,
                            maxScale: 2,
                            child: isNetwork
                                ? NetworkImageWidget(
                                    imageUrl: imagePath ?? '',
                                    imageHeight: height ?? height_300,
                                    imageWidth: width ?? height_250,
                                    imageFitType: BoxFit.contain,
                                    placeHolder: placeHolder,
                                    radiusAll: radius_10,
                                    includeBaseUrl: includeBaseUrl,
                                  )
                                : ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(radius_20),
                                    child: Image.file(
                                      File(imagePath ?? ''),
                                      fit: BoxFit.contain,
                                      height: height_300,
                                      width: height_250,
                                    ),
                                  ),
                          ),
                          TextView(
                            text: text ?? '',
                            maxLines: 1,
                            textStyle: textStyleHeadlineLarge()!
                                .copyWith(color: whiteAppColor),
                          )
                              .paddingOnly(bottom: margin_12, left: margin_4)
                              .paddingSymmetric(horizontal: margin_12),
                        ],
                      ),
                    ).paddingSymmetric(
                        horizontal: margin_15, vertical: margin_20),
                  ],
                ),
              ),
              SafeArea(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ).paddingOnly(top: margin_12, right: margin_12),
              ),
            ],
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    barrierDismissible: true,
    barrierLabel: '',
  );
}

void showProfileActionDialog(
    {required String title,
    String? subtitle,
    String? imagePath,
    String? cancelText,
    String? actionText,
    Color? color,
    Color? titleColor,
    VoidCallback? onTap}) {
  Get.generalDialog(
      barrierColor: Colors.black.withOpacity(0.15),
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInSine.transform(a1.value);
        return Transform.scale(
            scale: curve,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: margin_30),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(margin_5)),
                      child: Container(
                        decoration: BoxDecoration(
                            color: isDarkMode.value
                                ? AppColors.whiteLight
                                : Colors.white,
                            borderRadius: BorderRadius.circular(margin_5)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                AssetSVGWidget(imagePath ?? '',
                                        imageHeight: height_38,
                                        imageWidth: height_38)
                                    .paddingOnly(right: margin_10),
                                Expanded(
                                  child: TextView(
                                    text: title,
                                    textStyle: textStyleTitleLarge()!,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ).paddingOnly(bottom: margin_8),
                            TextView(
                              text: subtitle ?? '',
                              textStyle: textStyleTitleSmall()!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textGreyColor),
                              textAlign: TextAlign.start,
                              maxLines: 4,
                            ).paddingOnly(bottom: margin_14),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomMaterialButton(
                                    onTap: () {
                                      Get.back();
                                    },
                                    buttonHeight: height_35,
                                    borderColor: Color.fromRGBO(221,78,75,1),
                                    isOutlined: true,
                                    textColor: Color.fromRGBO(221,78,75,1),

                                    //  borderColor: color,
                                    buttonText: cancelText,
                                  ),
                                ),
                                SizedBox(width: height_12),
                                Expanded(
                                  child: CustomMaterialButton(
                                      onTap: onTap ??
                                          () {
                                            Get.back();
                                          },
                                      buttonHeight: height_35,
                                      bgColor: color,
                                      textColor: Colors.white,
                                      buttonText: actionText),
                                ),
                              ],
                            )
                          ],
                        ).paddingSymmetric(
                            horizontal: margin_15, vertical: margin_15),
                      )),
                ]));
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: true,
      barrierLabel: '');
}

void showMultiImageDialog(
    {required List<String>? imagesList,
    bool isNetwork = true,
    double? height,
    String? title,
    int? currentIndex,
    double? width}) {
  if (imagesList == null || imagesList.isEmpty) {
    return;
  }

  Get.generalDialog(
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      barrierColor: Colors.black,
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInSine.transform(a1.value);

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: FadeTransition(
            opacity: a1,
            child: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        title != null
                            ? Expanded(
                                child: TextView(
                                  text: title ?? '',
                                  textStyle: textStyleHeadlineSmall()!
                                      .copyWith(color: whiteAppColor),
                                ),
                              )
                            : const SizedBox(),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: AssetSVGWidget(
                            icCross,
                            imageHeight: height_22,
                            color: whiteAppColor,
                            imageWidth: height_22,
                          ),
                        ),
                      ],
                    )
                        .paddingSymmetric(horizontal: margin_15)
                        .paddingOnly(top: margin_8),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: height ?? height_250,
                          width: width ?? Get.width,
                          child: PageView.builder(
                            controller:
                                PageController(initialPage: currentIndex ?? 0),
                            itemBuilder: (context, index) {
                              return InteractiveViewer(
                                  panEnabled: false, // Set it to false
                                  minScale: 0.5,
                                  maxScale: 2,
                                  child: isNetwork
                                      ? NetworkImageWidget(
                                          imageUrl: imagesList[index],
                                          imageHeight: height ?? height_250,
                                          imageWidth: width ?? Get.width,
                                          imageFitType: BoxFit.cover,
                                        )
                                      : AssetImageWidget(
                                          imagesList[index],
                                          imageHeight: height_250,
                                          imageWidth: width ?? Get.width,
                                          imageFitType: BoxFit.cover,
                                        ));
                            },
                            itemCount: imagesList.length,
                          ),
                        )
                      ],
                    ).paddingOnly(bottom: margin_30),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: false,
      barrierLabel: '');
}

void showWidgetDialog({
  required Widget widget,
  bool canDismiss = true,
}) {
  Get.generalDialog(
      barrierColor: Colors.black.withOpacity(0.15),
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInSine.transform(a1.value);

        return Transform.scale(
          scale: curve,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: FadeTransition(
              opacity: a1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [widget],
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: canDismiss,
      barrierLabel: '');
}
