import 'package:good_citizen/app/export.dart';
import 'package:lottie/lottie.dart';

Future showMediaPickerDialog({
  bool allowImages = true,
  bool allowVideo = true,
  bool allowMultiple = false,
  VoidCallback? takeImage,
  VoidCallback? pickImage,
  VoidCallback? recordVideo,
  VoidCallback? pickVideo,
}) async {
  await Get.bottomSheet(Container(
    color: isDarkMode.value?AppColors.blackColor:whiteAppColor,
    child: Container(
      color: isDarkMode.value?AppColors.whiteLight:whiteAppColor,

      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 1.8),
        children: [
          allowMultiple
              ? _singleItemWidget(
                  keyPickImage.tr,
                  lottieFilesGallery,
                  onTap: () async {
                    Get.back();
                    if (pickImage != null) {
                      pickImage();
                    }
                  },
                )
              : _singleItemWidget(
                  keyGallery,
                  lottieFilesGallery,
                  onTap: () async {
                    Get.back();
                    if (pickImage != null) {
                      pickImage();
                    }
                  },
                ),
          if (allowImages) ...[
            _singleItemWidget(
              keyCamera,
              lottieFilesCamera,
              onTap: () {
                Get.back();
                if (takeImage != null) {
                  takeImage();
                }
              },
            ),
          ],
          if (allowVideo) ...[
            _singleItemWidget(
              keyRecVideo.tr,
              lottieFilesCamera,
              onTap: () {
                Get.back();
                if (recordVideo != null) {
                  recordVideo();
                }
              },
            ),
            _singleItemWidget(
              keyPickVideo.tr,
              lottieFilesGallery,
              onTap: () async {
                Get.back();
                if (pickVideo != null) {
                  pickVideo();
                }
              },
            ),
          ]
        ],
      )
          .paddingSymmetric(vertical: margin_15, horizontal: margin_25)
          .paddingOnly(top: margin_5),
    ),
  ));
}

Widget _singleItemWidget(String title, String imagePath,
    {VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(imagePath, height: height_40, width: height_40)
            .paddingOnly(bottom: margin_10),
        TextView(
          text: title,
          textAlign: TextAlign.center,
          maxLines: 1,
          textStyle: textStyleTitleSmall()!,
        ),
      ],
    ),
  );
}
