import 'package:good_citizen/app/modules/model/media_file_model.dart';

import '../../../core/widgets/network_image_widget.dart';
import '../../../core/widgets/show_dialog.dart';
import '../../../export.dart';

class EditViewWidget extends StatelessWidget {
  final MediaFile? mediaFile;
  final double? height;
  final double? width;
  final VoidCallback? onEditTap;

  const EditViewWidget(
      {super.key, this.mediaFile, this.width, this.height, this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return _previewWidget();
  }

  Widget _previewWidget() => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {
      showImageDialog(
          imagePath:
          mediaFile?.networkPath ?? mediaFile?.localPath,
          isNetwork: mediaFile?.localPath == null);
    },
    child: Stack(
          alignment: Alignment.topRight,
          clipBehavior: Clip.none,
          children: [
            mediaFile?.localPath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(radius_12),
                    child: Image.file(
                      File(mediaFile?.localPath ?? ''),
                      fit: BoxFit.cover,
                      height: height_150,
                      width: Get.width,
                    ))
                : NetworkImageWidget(
                    imageUrl: mediaFile?.networkPath ?? '',
                    imageHeight: height_150,
                    imageWidth: Get.width,
                    radiusAll: radius_12,
                  ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: onEditTap,
                    child: AssetSVGWidget(
                      icImageEditIcon,
                      imageWidth: height_28,
                      imageHeight: height_28,
                    ),
                  ).paddingOnly(right: margin_3),
                  // GestureDetector(
                  //   behavior: HitTestBehavior.translucent,
                  //   onTap: () {
                  //     showImageDialog(
                  //         imagePath:
                  //             mediaFile?.networkPath ?? mediaFile?.localPath,
                  //         isNetwork: mediaFile?.localPath == null);
                  //   },
                  //   child: AssetSVGWidget(
                  //     icImageView,
                  //     imageWidth: height_28,
                  //     imageHeight: height_28,
                  //   ),
                  // ),
                ],
              ).paddingAll(margin_8),
            ),
          ],
        ),
  );
}
