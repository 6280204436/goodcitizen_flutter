import '../../../core/utils/common_methods.dart';
import '../../../export.dart';
import '../controllers/account_info_controller.dart';

class AccountInfoScreen extends GetView<AccountInfoController> {
  const AccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      extendBodyBehindAppBar: false,
      appBar: _appBarWidget(),
      body:Obx(() => _bodyWidget(),),
    );
  }

  AppBar _appBarWidget() {
    return customAppBar(
      titleText: keyAccountInfo.tr,
    );
  }

  Widget _bodyWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _singleItemWidget(
            keyAccountInformation.tr,
            value: '${keyName.tr}, ${keyEmail.tr}',
            type: editTypeName,
            onTap: () {
              Get.toNamed(AppRoutes.accountDetailRoute);
            },
          ),
          commonDividerWidget().paddingSymmetric(vertical: margin_7),
          _singleItemWidget(
            keyPhoneNumber.tr,
            value: profileDataProvider.userDataModel.value?.phone != null
                ? '+${profileDataProvider.userDataModel.value?.countryCode ?? ''} ${profileDataProvider.userDataModel.value?.phone ?? ''}'
                : keyAddPhone.tr,
            imagePath:
            (profileDataProvider.userDataModel.value?.isPhoneVerify == true)
                ? icVerifiedCab
                : null,
            onTap: () async {
              await Get.toNamed(AppRoutes.editItemRoute,
                  arguments: {argType: editTypePhone});

            },
          ),
          // commonDividerWidget().paddingSymmetric(vertical: margin_7),
          // _singleItemWidget(
          //   keyVehDetails.tr,
          //   value: keyYourVehs,
          //
          //   onTap: () {
          //     Get.toNamed(AppRoutes.vehicleListRoute);
          //   },
          // ),
        ],
      ).paddingSymmetric( horizontal: margin_15).paddingOnly(top: margin_8),
    );
  }

  Widget _singleItemWidget(String title,
      {String? value,
      String? imagePath,
      double? radius,
      int? type,
      VoidCallback? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView(
                        text: title,
                        textStyle: textStyleTitleLarge()
                            !.copyWith(fontWeight: FontWeight.w600))
                    .paddingOnly(bottom: margin_5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        child: TextView(
                      text: value ?? '',
                      maxLines: 15,
                      textStyle: textStyleTitleLarge()!.copyWith(
                          color: AppColors.textGreyColor,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.start,
                    )),
                    imagePath != null
                        ? AssetSVGWidget(
                            imagePath,
                            imageHeight: height_15,
                            imageWidth: height_15,
                          ).paddingOnly(left: margin_5)
                        : const SizedBox()
                  ],
                ),
              ],
            ).paddingSymmetric(),
          ),
          nextIconImage(color: AppColors.darkGreyColor)
        ],
      ),
    );
  }
}
