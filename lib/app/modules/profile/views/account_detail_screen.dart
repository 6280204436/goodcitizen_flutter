import 'package:good_citizen/app/core/widgets/custom_app_bar.dart';
import 'package:good_citizen/app/core/widgets/network_image_widget.dart';
import 'package:good_citizen/app/core/widgets/show_dialog.dart';
import 'package:good_citizen/app/core/widgets/text_view_widget.dart';
import 'package:good_citizen/app/modules/profile/controllers/account_detail_controller.dart';

import '../../../export.dart';



class AccountDetailScreen extends GetView<AccountDetailController> {
  const AccountDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      extendBodyBehindAppBar: false,
      appBar: _appBarWidget(),
      body: Obx(() => _bodyWidget()),
    );
  }

  AppBar _appBarWidget() {
    return customAppBar(
        titleText: keyAccountInformation.tr,
        actions: GestureDetector(
          onTapDown: (details) => _showMenuWidget(details.globalPosition),
          child: AssetSVGWidget(
            icThreeDot,color: isDarkMode.value?Colors.white:AppColors.appColor,
            imageWidth: height_20,
            imageHeight: height_20,
          ),
        ));
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _imageWidget().paddingOnly(bottom: margin_25),
                _singleFieldWidget(
                    keyName,
                    profileDataProvider.userDataModel.value?.name ?? '',
                    editTypeName)
                    .paddingOnly(bottom: margin_20),
                _singleFieldWidget(
                    keyEmail,
                    profileDataProvider.userDataModel.value?.email ??
                        profileDataProvider.userDataModel.value?.tempEmail ??
                        '',
                    editTypeEmail,
                    suffix: profileDataProvider
                        .userDataModel.value?.isEmailVerify ==
                        true
                        ? icVerifiedCab
                        : null)
              ],
            ),
          ),
        ),
        Visibility(
            visible: controller.isImageTaken.value,
            child: SafeArea(
              child: CustomMaterialButton(
                  buttonText: keySave, onTap: controller.uploadImage),
            ))
      ],
    ).paddingSymmetric(vertical: margin_10, horizontal: margin_15);
  }

  Widget _imageWidget() {
    return GestureDetector(
      onTap: () => showImageDialog(
        imagePath:controller.imageFile.value.localPath ?? profileDataProvider.userDataModel.value?.image ?? '',
        isNetwork: controller.imageFile.value.localPath ==null,
        includeBaseUrl: profileDataProvider.userDataModel.value?.loginType ==
            loginTypeNormal,
        placeHolder: userPlaceholder,
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.appGreyColorDark),
            child: controller.imageFile.value.localPath != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(
                radius_100,
              ),
              child: Image.file(
                File(controller.imageFile.value.localPath!),
                height: height_100,
                width: height_100,
                fit: BoxFit.cover,
              ),
            ).paddingAll(margin_4)
                : NetworkImageWidget(
              imageUrl:
              profileDataProvider.userDataModel.value?.image ?? '',
              imageHeight: height_100,
              imageWidth: height_100,
              includeBaseUrl:
              profileDataProvider.userDataModel.value?.loginType ==
                  loginTypeNormal,
              imageFitType: BoxFit.cover,
              fileSizeEnum: FileSizeEnum.medium,
              placeHolder: userPlaceholder,
              radiusAll: radius_100,
            ).paddingAll(margin_4),
          ),
          GestureDetector(
            onTap: controller.pickImage,
            child: Container(
              decoration: BoxDecoration(
                  color: isDarkMode.value ? Colors.white : AppColors.appColor,
                  borderRadius: BorderRadius.circular(margin_38)),
              child: Icon(
                Icons.edit,size: margin_20,
                color: isDarkMode.value ? AppColors.appColor : Colors.white,
              ).paddingAll(margin_5),
            ).paddingOnly(right: margin_3, bottom: margin_2),
          ),
        ],
      ),
    );
  }

  Widget _singleFieldWidget(String? title, String? value, var editType,
      {String? suffix}) {
    TextEditingController textEditingController =
    TextEditingController(text: value ?? '');
    return GestureDetector(
      onTap: () async {
        await Get.toNamed(AppRoutes.editItemRoute,
            arguments: {argType: editType});
        controller.getSavedProfileData();
      },
      child: TextFieldWidget(
        controller: textEditingController,
        hintText: title,
        enabled: false,
        labelText: title,
        suffixIcon: suffix != null
            ? AssetSVGWidget(
          suffix,
          imageHeight: height_15,
          imageWidth: height_15,
        ).paddingSymmetric(horizontal: margin_11)
            : null,
        inputType: TextInputType.text,
      ),
    );
  }

  void _showMenuWidget(Offset globalPosition) async {
    double left = globalPosition.dx;
    double top = globalPosition.dy;

    final result = await showMenu(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(margin_4)),
      context: Get.overlayContext!,
      position: RelativeRect.fromLTRB(left, top + margin_18, margin_25, 0),
      items: [
        PopupMenuItem<String>(
          height: height_20,
          value: deleteAccountConst,
          child: TextView(
            text: keyDeleteAcc,
            textStyle:
            textStyleTitleLarge()!.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
      elevation: 1.0,
    );
    _detailAction(result);
  }

  void _detailAction(String? result) async {
    if (result == null) {
      return;
    }
    switch (result) {
      case deleteAccountConst:
        {
          showProfileActionDialog(
              title: keyDltYourAcc.tr,
              subtitle: keyDltYourAccDes.tr,
              actionText: keyYes.tr,
              cancelText: keyNo.tr,
              imagePath: icDeleteCab,
              onTap: () {
                Get.back();
                controller.deleteAccount();
              },
              titleColor: AppColors.appColor,
              color: AppColors.appRedColor);
        }
    }
  }
}
