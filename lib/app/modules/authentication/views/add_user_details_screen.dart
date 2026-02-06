import 'package:good_citizen/app/modules/authentication/controllers/add_user_details_controller.dart';

import '../../../core/utils/email_formatter.dart';
import '../../../core/widgets/network_image_widget.dart';
import '../../../core/widgets/show_dialog.dart';
import '../../../export.dart';
import '../../model/media_file_model.dart';
import '../../profile/widgets/edit_view_widget.dart';

class AddUserDetailsScreen extends GetView<AddUserDetailsController> {
  const AddUserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(),
      resizeToAvoidBottomInset: false,
      body: Obx(() => _bodyWidget()),
    );
  }

  AppBar _appBarWidget() {
    return customAppBar(titleText: keyEnterYourDetails);
  }

  Widget _bodyWidget() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(child: _formWidget()),
          CustomMaterialButton(
            onTap: controller.validate,
            enabled: controller.licFront.value != null &&
                controller.licBack.value != null &&
                (controller.nameString.value != '' &&
                    controller.emailString.value != '') &&
                controller.imageFile.value != null,
            buttonText: keySubmit.tr,
          ).paddingOnly(bottom: margin_10),
        ],
      ).paddingSymmetric(horizontal: margin_15).paddingOnly(top: margin_8),
    );
  }

  Widget _formWidget() {
    return SingleChildScrollView(child: _fieldWidgets());
  }

  Widget _fieldWidgets() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          _imageWidget().paddingOnly(bottom: margin_20),
          _nameField().paddingOnly(bottom: margin_20),
          _emailField().paddingOnly(bottom: margin_22),
          _docsWidget().paddingOnly(bottom: margin_20),
        ],
      ),
    );
  }

  Widget _imageWidget() {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          controller.imageFile.value?.localPath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(
                    radius_100,
                  ),
                  child: GestureDetector(
                    onTap: _showImage,
                    child: Image.file(
                      File(controller.imageFile.value!.localPath!),
                      height: height_100,
                      width: height_100,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: _showImage,
                  child: NetworkImageWidget(
                    imageUrl: controller.imageFile.value?.networkPath ?? '',
                    imageHeight: height_100,
                    imageWidth: height_100,
                    imageFitType: BoxFit.cover,
                    placeHolder: userPlaceholder,
                    radiusAll: radius_100,
                  ),
                ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: controller.pickImage,
            child: Container(
              decoration: BoxDecoration(
                  color: isDarkMode.value ? Colors.white : AppColors.appColor,
                  borderRadius: BorderRadius.circular(margin_38)),
              child: Icon(
                Icons.edit,size: margin_20,
                color: isDarkMode.value ? AppColors.appColor : Colors.white,
              ).paddingAll(margin_5),
            )
          ),
        ],
      ),
    );
  }

  void _showImage() {
    showImageDialog(
      imagePath: controller.imageFile.value?.localPath ??
          profileDataProvider.userDataModel.value?.image ??
          '',
      isNetwork: controller.imageFile.value?.localPath == null,
      includeBaseUrl:
          profileDataProvider.userDataModel.value?.loginType == loginTypeNormal,
      placeHolder: userPlaceholder,
    );
  }

  TextFieldWidget _nameField() {
    return TextFieldWidget(
      controller: controller.nameController,
      focusNode: controller.nameNode,
      hintText: keyEnterName.tr,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
        CapitalizeFirstLetterTextFormatter(),
      ],
      labelText: keyName,
      validator: (String? value) {
        return FieldChecker.fieldChecker(
            value: value?.trim() ?? "", completeMessage: keyPlsEnterYourName);
      },
      onChanged: (value) {
        controller.nameString.value = value;
      },
      maxLength: 30,
      inputType: TextInputType.text,
      textInputAction: TextInputAction.next,
    );
  }

  TextFieldWidget _emailField() {
    return TextFieldWidget(
      controller: controller.emailController,
      textInputAction: TextInputAction.done,
      focusNode: controller.emailFocusNode,
      hintText: keyEnterEmail.tr,
      labelText: keyEmail,
      onChanged: (value) {
        controller.emailString.value = value;
      },
      inputFormatters: [EmailTextInputFormatter()],
      validator: (value) => EmailValidator.validateEmail(
          title: keyEmail.tr.toLowerCase(), value: value?.trim() ?? ""),
      inputType: TextInputType.emailAddress,
    );
  }

  Widget _docsWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextView(
              text: keyUploadDocs.tr,
              maxLines: 2,
              textStyle: textStyleDisplaySmall()!
                  .copyWith(fontWeight: FontWeight.w500))
          .paddingOnly(bottom: margin_10),
      _singleDocItem(
        keyLicFront,
        isCompleted: controller.licFront.value != null,
        imageFile: controller.licFront.value,
        onEdit: () async {
          controller.emailFocusNode.unfocus();
          final result = await Get.toNamed(AppRoutes.takePhotoRoute,
              arguments: {argData: controller.licFront.value});
          if (result is MediaFile) {
            controller.licFront.value = result;
            controller.licFront.refresh();
          }
        },
      ).paddingOnly(bottom: margin_12),
      _singleDocItem(
        keyLicBack,
        imageFile: controller.licBack.value,
        isCompleted: controller.licBack.value != null,
        onEdit: () async {
          final result = await Get.toNamed(AppRoutes.takePhotoRoute,
              arguments: {argData: controller.licBack.value});
          if (result is MediaFile) {
            controller.licBack.value = result;
            controller.licBack.refresh();
          }
        },
      ),
    ]);
  }

  // Widget _singleDocItem(String title,
  //     {bool isCompleted = false, VoidCallback? onTap}) {
  //   return GestureDetector(
  //     behavior: HitTestBehavior.translucent,
  //     onTap: onTap,
  //     child: Container(
  //       decoration: BoxDecoration(
  //           color: AppColors.appGreyColor,
  //           borderRadius: BorderRadius.circular(
  //             radius_5,
  //           )),
  //       child: Row(
  //         children: [
  //           Expanded(
  //               child: TextView(
  //                   text: title,
  //                   textStyle: textStyleTitleLarge()
  //                       .copyWith(fontWeight: FontWeight.w400))),
  //           AssetSVGWidget(
  //             isCompleted ? icGreenTick : icNextIcon,
  //             imageHeight: height_12,
  //             imageWidth: height_12,
  //             color: !isCompleted ? AppColors.greyColor.withOpacity(0.7) : null,
  //           ).paddingOnly(left: margin_5)
  //         ],
  //       ).paddingSymmetric(horizontal: margin_10, vertical: margin_14),
  //     ),
  //   );
  // }

  Widget _singleDocItem(String title,
      {bool isCompleted = false, VoidCallback? onEdit, MediaFile? imageFile}) {
    return (imageFile?.localPath == null && imageFile?.networkPath == null)
        ? GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onEdit,
            child: Container(
              decoration: BoxDecoration(
                  color: isDarkMode.value
                      ? AppColors.whiteLight
                      : AppColors.appGreyColor,
                  borderRadius: BorderRadius.circular(
                    radius_5,
                  )),
              child: Row(
                children: [
                  Expanded(
                      child: TextView(
                          text: title,
                          textStyle: textStyleTitleLarge()!
                              .copyWith(fontWeight: FontWeight.w400))),
                  AssetSVGWidget(
                    isCompleted ? icGreenTick : icNextIcon,
                    imageHeight: height_12,
                    imageWidth: height_12,
                    color: !isCompleted
                        ? isDarkMode.value
                            ? AppColors.whiteAppColor
                            : AppColors.greyColor.withOpacity(0.7)
                        : null,
                  ).paddingOnly(left: margin_5)
                ],
              ).paddingSymmetric(horizontal: margin_10, vertical: margin_14),
            ),
          )
        : GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView(
                        text: title,
                        textStyle: textStyleTitleLarge()!
                            .copyWith(fontWeight: FontWeight.w400))
                    .paddingOnly(bottom: margin_12),
                EditViewWidget(
                  mediaFile: imageFile,
                  onEditTap: onEdit,
                )
              ],
            ),
          );
  }
}
