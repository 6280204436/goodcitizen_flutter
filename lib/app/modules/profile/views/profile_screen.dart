import 'package:good_citizen/app/core/widgets/network_image_widget.dart';
import 'package:good_citizen/app/core/widgets/show_dialog.dart';
import 'package:good_citizen/app/modules/location_provider/native_location_services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'dart:io';

import '../../../export.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(221, 78, 75, 1),
        extendBody: false,
        appBar: _appBarWidget(),
        body: Obx(() => _bodyWidget().paddingOnly(bottom: margin_0)));
  }

  AppBar _appBarWidget() {
    return customAppBar(
      bgColor: Color.fromRGBO(221, 78, 75, 1),
      titleText: keyProfile.tr,
    );
  }

  Widget _bodyWidget() {
    return _bodyList().paddingOnly(bottom: margin_0);
  }

  Widget _bodyList() {
    return Container(
        height: Get.height * 0.865,
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _profileWidget(),
              Obx(
                      () => controller.loyaltyPoints.value != null &&
                      controller.userResponseModel?.value?.data?.role ==
                          "USER"
                      ? Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: AppColors.whiteAppColor,
                        image: DecorationImage(
                            image: AssetImage(
                              imageBackgroundProfile,
                            ),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(radius_5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextView(
                            text: "Loyalty Points",
                            maxLines: 1,
                            textStyle: textStyleTitleLarge()!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 14),
                            textAlign: TextAlign.start,
                          ).paddingSymmetric(vertical: margin_25),
                          TextView(
                            text:
                            "${controller.loyaltyPoints.toString()} Points",
                            maxLines: 1,
                            textStyle: textStyleTitleLarge()!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 14),
                            textAlign: TextAlign.start,
                          ).paddingSymmetric(vertical: margin_25),
                        ],
                      ).marginSymmetric(horizontal: margin_27))
                      .marginSymmetric(horizontal: 10)
                      :SizedBox()

              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.changePasswordRouteUser);
                },
                child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: AppColors.whiteAppColor,
                      image: DecorationImage(
                          image: AssetImage(
                            imageBackgroundProfile,
                          ),
                          fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(radius_5),
                    ),
                    child: Row(
                      children: [
                        // AssetImageWidget(icon,imageWidth: width_20,imageHeight: height_20,).marginSymmetric(horizontal: margin_10),
                        Icon(
                          Icons.update,
                          color: AppColors.appColor,
                        ).marginSymmetric(horizontal: 10),

                        TextView(
                          text: "Password Update",
                          maxLines: 1,
                          textStyle: textStyleTitleLarge()!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 14),
                          textAlign: TextAlign.start,
                        ).marginSymmetric(horizontal: margin_10),
                      ],
                    ).paddingSymmetric(
                        horizontal: margin_25, vertical: margin_25)),
              ).marginSymmetric(horizontal: 10),

              controller.userResponseModel?.value?.data?.role ==
                  "USER"?SizedBox() : GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.myDocumentView);
                },
                child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: AppColors.whiteAppColor,
                      image: DecorationImage(
                          image: AssetImage(
                            imageBackgroundProfile,
                          ),
                          fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(radius_5),
                    ),
                    child: Row(
                      children: [
                        // AssetImageWidget(icon,imageWidth: width_20,imageHeight: height_20,).marginSymmetric(horizontal: margin_10),
                        Icon(
                          Icons.file_present_outlined,
                          color: AppColors.appColor,
                        ).marginSymmetric(horizontal: 10),

                        TextView(
                          text: "My Documents",
                          maxLines: 1,
                          textStyle: textStyleTitleLarge()!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 14),
                          textAlign: TextAlign.start,
                        ).marginSymmetric(horizontal: margin_10),
                      ],
                    ).paddingSymmetric(
                        horizontal: margin_25, vertical: margin_25)),
              ).marginSymmetric(horizontal: 10),
              _routeWidget("Terms of conditions", iconTerms, () {
                Get.toNamed(AppRoutes.staticPageRoute,
                    arguments: {"from": "Terms"});
              }),
              _routeWidget("Privacy Policy", iconsPrivacy, () {
                Get.toNamed(AppRoutes.staticPageRoute,
                    arguments: {"from": "Privacy"});
              }),
              _routeWidget("About Us", iconsPrivacy, () {
                Get.toNamed(AppRoutes.staticPageRoute,
                    arguments: {"from": "About"});
              }),
              _routeWidget("Share App", iconShare, () async {
                await _shareApp();
              }),
              _buttonWidget().marginOnly(bottom: margin_55)
            ],
          ),
        )).marginOnly(top: margin_20);
  }

  Widget _profileWidget() {
    return GestureDetector(
      onTap: () async {
        await Get.toNamed(AppRoutes.personalInfoRoute);
      },
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: height_40,
                width: Get.width - 20,
                decoration: BoxDecoration(
                  color: AppColors.whiteAppColor,
                  borderRadius: BorderRadius.circular(radius_5),
                ),
              ),
              Container(
                height: height_140,
                width: Get.width - 20,
                decoration: BoxDecoration(
                  color: AppColors.whiteAppColor,
                  image: DecorationImage(
                    image: AssetImage(imageBackgroundProfile!),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(radius_5),
                ),
              ),
            ],
          ),
          Positioned(
            right: margin_70,
            top: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => showImageDialog(
                    imagePath:
                    controller.userResponseModel.value?.data?.profile_pic ??
                        '',
                    placeHolder: userPlaceholder,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.appGreyColorDark,
                    ),
                    child: NetworkImageWidget(
                      imageUrl: controller
                          .userResponseModel.value?.data?.profile_pic ??
                          "",
                      imageHeight: height_60,
                      imageWidth: height_60,
                      includeBaseUrl: true,
                      placeHolder: userPlaceholder,
                      radiusAll: radius_40,
                    ).paddingAll(margin_4),
                  ),
                ).paddingOnly(top: margin_10),
                Obx(
                      () => TextView(
                    text: controller.name.value,
                    maxLines: 2,
                    textStyle: textStyleTitleLarge()!.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ).paddingOnly(top: margin_8),
                ),
                Obx(
                      () => controller.userResponseModel.value?.data?.phonenumber !=
                      null
                      ? TextView(
                    text:
                    "+${controller.userResponseModel.value?.data?.countrycode ?? ""} ${controller.userResponseModel.value?.data?.phonenumber ?? ""}",
                    maxLines: 2,
                    textStyle: textStyleTitleLarge()!.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ).paddingOnly(top: margin_3)
                      : SizedBox(),
                ),
                Obx(
                      () => Container(
                    width: width_200,
                    child: TextView(
                      text: controller.useremail.value,
                      maxLines: 2,
                      textStyle: textStyleTitleLarge()!.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ).paddingOnly(top: margin_3),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: width_30,
            top: height_70,
            child: GestureDetector(
              onTap: () async {
                await Get.toNamed(AppRoutes.editProfileRoute);
                controller.loadProfile();
              },
              child: Icon(
                Icons.edit,
                color: Color.fromRGBO(221, 78, 75, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _routeWidget(String? title, icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: Get.width,
          decoration: BoxDecoration(
            color: AppColors.whiteAppColor,
            image: DecorationImage(
                image: AssetImage(
                  imageBackgroundProfile,
                ),
                fit: BoxFit.fill),
            borderRadius: BorderRadius.circular(radius_5),
          ),
          child: Row(
            children: [
              AssetImageWidget(
                icon,
                imageWidth: width_20,
                imageHeight: height_20,
              ).marginSymmetric(horizontal: margin_10),
              TextView(
                text: title ?? "",
                maxLines: 1,
                textStyle: textStyleTitleLarge()!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 14),
                textAlign: TextAlign.start,
              ).marginSymmetric(horizontal: margin_10),
            ],
          ).paddingSymmetric(horizontal: margin_25, vertical: margin_25)),
    ).marginSymmetric(horizontal: 10);
  }

  Widget _buttonWidget() {
    return Column(
      children: [
        CustomMaterialButton(
          bgColor: Color.fromRGBO(221, 78, 75, 1),
          textColor: Colors.white,
          borderRadius: 30,
          onTap: () {
            showProfileActionDialog(
                title: "Logout",
                subtitle: keySignOutDes.tr,
                actionText: keyYes.tr,
                cancelText: keyNo.tr,
                imagePath: icSignOut,
                onTap: () async {
                  Get.back();

                  if (controller.userResponseModel.value?.data?.rideid ==
                      null) {
                    controller.logout();
                  } else {
                    showSnackBar(
                        message: "You can log out once your ride is complete.");
                  }
                },
                color: Color.fromRGBO(221, 78, 75, 1));
          },
          buttonText: "Logout",
        ).marginSymmetric(horizontal: 60, vertical: 20),
        GestureDetector(
          onTap: () {
            showProfileActionDialog(
                title: "Delete Account",
                subtitle:"Are you Sure that you want to Delete Account?",
                actionText: keyYes.tr,
                cancelText: keyNo.tr,
                imagePath: icSignOut,
                onTap: () async {
                  Get.back();

                  if (controller.userResponseModel.value?.data?.rideid ==
                      null) {
                    controller.DeleteAccount();
                  } else {
                    showSnackBar(
                        message: "You can Delete Account once your ride is complete.");
                  }
                },
                color: Color.fromRGBO(221, 78, 75, 1));
          },
          child: TextView(
            text: "Delete Account",
            maxLines: 1,
            textStyle: textStyleTitleLarge()!.copyWith(
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(221, 78, 75, 1),
                fontSize: 14),
            textAlign: TextAlign.start,
          ).marginSymmetric(horizontal: margin_10),
        ),
      ],
    );
  }

  Future<void> _shareApp() async {
    try {
      // Get platform-specific app store URLs
      final String appStoreUrl = await _getAppStoreUrl();

      // Generate deep link for app sharing with user ID if available
      final String? userId = controller.userResponseModel.value?.data?.sId;


      // App description with platform-specific content
      final String appDescription = _getAppDescription(appStoreUrl,"https://api.agoodcitizen.in");

      // Share the app
      await Share.share(
        appDescription,
        subject: 'Check out Good Citizen - Your Trusted Ride Partner!',
      );
    } catch (e) {
      debugPrint('Error sharing app: $e');
      // Show error message to user
      showSnackBar(
        message: 'Unable to share app. Please try again.',
      );
    }
  }

  // Advanced share method with optional image (for future use)
  Future<void> _shareAppWithImage() async {
    try {
      final String appStoreUrl = await _getAppStoreUrl();
      final String? userId = controller.userResponseModel.value?.data?.sId;
      // final String deepLink = deepLinkService.generateAppSharingLink(
      //   userId: userId,
      // );
      final String appDescription = _getAppDescription(appStoreUrl,"https://api.agoodcitizen.in");

      // You can add app screenshots or promotional images here
      // For now, we'll just share text
      await Share.share(
        appDescription,
        subject: 'Good Citizen - Download Now!',
      );
    } catch (e) {
      debugPrint('Error sharing app with image: $e');
      showSnackBar(
        message: 'Unable to share app. Please try again.',
      );
    }
  }

  _getAppStoreUrl() async {
    try {
      // Get package info dynamically
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String packageName = packageInfo.packageName;

      // You should replace these with your actual app store URLs
      if (Platform.isAndroid) {
        return 'https://play.google.com/store/apps/details?id=$packageName';
      } else if (Platform.isIOS) {
        // For iOS, you'll need to replace this with your actual App Store ID
        return 'https://apps.apple.com/app/goodcitizen/id123456789';
      } else {
        // Fallback for web or other platforms
        return 'https://goodcitizen.app';
      }
    } catch (e) {
      debugPrint('Error getting app store URL: $e');
      // Fallback URLs
      if (Platform.isAndroid) {
        return 'https://play.google.com/store/apps/details?id=com.pr.goodcitizen';
      } else if (Platform.isIOS) {
        return 'https://apps.apple.com/app/goodcitizen/id123456789';
      } else {
        return 'https://goodcitizen.app';
      }
    }
  }

  String _getAppDescription(String appStoreUrl, String deepLink) {
    return '''
🚗 Good Citizen - Your Trusted Ride Partner!

Experience safe, reliable, and convenient transportation with Good Citizen. Whether you need a quick ride across town or a comfortable journey to your destination, we've got you covered.

✨ Features:
• Safe and verified drivers
• Real-time tracking
• Multiple payment options
• 24/7 customer support
• Competitive pricing
• Easy booking process

Download now and join thousands of satisfied users!

📱 Download: $appStoreUrl
// 🔗 Open App: $deepLink

#GoodCitizen #RideSharing #SafeTransport #ConvenientTravel
      ''';
  }
}
