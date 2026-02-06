import 'package:good_citizen/app/modules/model/media_file_model.dart';
import 'package:good_citizen/app/modules/profile/widgets/edit_view_widget.dart';
import 'package:good_citizen/app/modules/profile/widgets/expiring_text_view.dart';

import '../../../core/utils/common_methods.dart';
import '../../../core/widgets/show_dialog.dart';
import '../../../export.dart';
import '../controllers/my_docs_controller.dart';

class MyDocsScreen extends GetView<MyDocsController> {
  const MyDocsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      extendBodyBehindAppBar: false,
      appBar: _appBarWidget(),
      body: Obx(
        () => _bodyWidget(),
      ),
    );
  }

  AppBar _appBarWidget() {
    return customAppBar(
      titleText: keyDocuments,
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerText(keyDrivingLicense)
                    .paddingOnly(bottom: margin_18, top: margin_10),
                _singleItemWidget(
                  keyLicFront,
                  imageFile: controller.licFront.value,
                  isCompleted:
                      profileDataProvider.userDataModel.value?.licFront != null,
                  onEdit: () async {
                    final result = await Get.toNamed(AppRoutes.takePhotoRoute,
                        arguments: {argData: controller.licFront.value});
                    if (result is MediaFile) {
                      controller.licFront.value = result;
                      controller.licFront.refresh();
                    }
                  },
                ).paddingOnly(bottom: margin_10),
                _singleItemWidget(
                  keyLicBack,
                  imageFile: controller.licBack.value,
                  isCompleted:
                      profileDataProvider.userDataModel.value?.licBack != null,
                  onEdit: () async {
                    final result = await Get.toNamed(AppRoutes.takePhotoRoute,
                        arguments: {argData: controller.licBack.value});
                    if (result is MediaFile) {
                      controller.licBack.value = result;
                      controller.licBack.refresh();
                    }
                  },
                ).paddingOnly(bottom: margin_20),
              ],
            ),
          ),
        ),
        Visibility(
            visible: controller.licFront.value?.localPath != null ||
                controller.licBack.value?.localPath != null,
            child: _buttonWidget())
      ],
    ).paddingSymmetric(vertical: margin_0, horizontal: margin_15);
  }

  Widget _headerText(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextView(
                text: text,
                textStyle: textStyleHeadlineMedium()
                    !.copyWith(fontWeight: FontWeight.w500))
            .paddingOnly(bottom: margin_5),
        ExpiringTextView(
            date: profileDataProvider.userDataModel.value?.licExpiryDate),
      ],
    );
  }

  Widget _singleItemWidget(String title,
      {bool isCompleted = false, VoidCallback? onEdit, MediaFile? imageFile}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextView(
                  text: title,
                  textStyle: textStyleTitleLarge()
                      !.copyWith(fontWeight: FontWeight.w400))
              .paddingOnly(bottom: margin_12),
          EditViewWidget(
            mediaFile: imageFile,
            onEditTap: onEdit,
          )
        ],
      ),
    );
  }

  Widget _buttonWidget() {
    return SafeArea(
      top: false,
      child: CustomMaterialButton(
        onTap:controller.handleUpdate,
        buttonText: keyUpdate.tr,
      ).paddingOnly(bottom: margin_10, top: margin_10),
    );
  }
}
