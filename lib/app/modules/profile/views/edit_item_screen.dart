import 'package:dotted_border/dotted_border.dart';
import 'package:good_citizen/app/core/widgets/network_image_widget.dart';
import 'package:good_citizen/app/core/widgets/show_dialog.dart';

import '../../../core/utils/common_item_model.dart';
import '../../../core/utils/email_formatter.dart';
import '../../../core/widgets/drop_down_text_widget.dart';
import '../../../core/widgets/intl_phone_field/countries.dart';
import '../../../export.dart';
import '../../authentication/models/auth_request_model.dart';
import '../controllers/edit_item_controller.dart';
import '../controllers/profile_controller.dart';

class EditProfileScreen extends GetView<EditItemController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(221, 78, 75, 1),
        extendBody: false,
        appBar: _appBarWidget(),
        body: _bodyWidget().paddingOnly(bottom: margin_0));
  }

  AppBar _appBarWidget() {
    return customAppBar(
      bgColor: Color.fromRGBO(221, 78, 75, 1),
      titleText: "Profile",
    );
  }

  Widget _bodyWidget() {
    return _bodyList().paddingOnly(bottom: margin_0);
  }

  Widget _bodyList() {
    return Container(
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => _imageWidget()).marginSymmetric(vertical: 30),
              _firstname().marginSymmetric(horizontal: 20),
              _lastname().marginSymmetric(horizontal: 20, vertical: 20),
              _emailField().marginSymmetric(horizontal: 20),
              _phoneField(),
              _countryDropDown().marginSymmetric(horizontal: 20),
              // Obx(() => _AdharcardfrontWidget()).marginSymmetric(vertical: 30),
              // Obx(() => _AdharcardbackWidget()).marginSymmetric(vertical: 30),
              _buttonWidget()
            ],
          ),
        )).marginOnly(
      top: margin_20,
    );
  }

  Widget _phoneField() {
    return CountryPickerTextField(
      controller: controller.numberController,
      focusNode: controller.phoneNode,
      labelText: "Phone Number",
      pickerKey: controller.countryPickerKey,
      hintText: "Enter Your Phone number",
      selectedCountry: controller.selectedCountry,
      showBorder: true,
      onChanged: (value) {},
      onCountryChanged: (value) {
        controller.selectedCountry.value = value;
      },
    ).marginSymmetric(horizontal: 20, vertical: 20);
  }

  Widget _countryDropDown() {
    return TextFieldWidget(
      controller: controller.genderController,
      textInputAction: TextInputAction.done,
      focusNode: controller.genderFocusNode,
      hintText: "Enter your gender",
      labelText: "Gender",
      labelTextStyle: textStyleTitleSmall()!
          .copyWith(fontWeight: FontWeight.w400, color: Colors.black),
      enabled: false,
      inputType: TextInputType.text,
    );
  }

  TextFieldWidget _firstname() {
    return TextFieldWidget(
      controller: controller.stateController,
      textInputAction: TextInputAction.done,
      focusNode: controller.stateFocusNode,
      hintText: "Enter your first name",
      labelTextStyle: textStyleTitleSmall()!
          .copyWith(fontWeight: FontWeight.w400, color: Colors.black),
      labelText: "First Name",
      // onChanged: (value) {
      //   controller.emailString.value = value;
      // },
      inputFormatters: [NameTextInputFormatter()],
      validator: (value) => NameValidator.validateName(
        title: "First Name".toLowerCase(),
        value: value?.trim() ?? '',
      ),
      inputType: TextInputType.emailAddress,
    );
  }

  TextFieldWidget _lastname() {
    return TextFieldWidget(
      controller: controller.cityController,
      textInputAction: TextInputAction.done,
      focusNode: controller.cityNode,
      hintText: "Enter your last name",
      labelTextStyle: textStyleTitleSmall()!
          .copyWith(fontWeight: FontWeight.w400, color: Colors.black),
      labelText: "Last Name",
      // onChanged: (value) {
      //   controller.emailString.value = value;
      // },
      inputFormatters: [NameTextInputFormatter()],
      validator: (value) => NameValidator.validateName(
        title: "Last Name".toLowerCase(),
        value: value?.trim() ?? '',
      ),
      inputType: TextInputType.emailAddress,
    );
  }

  TextFieldWidget _emailField() {
    return TextFieldWidget(
      controller: controller.emailController,
      textInputAction: TextInputAction.done,
      focusNode: controller.emailFocusNode,
      hintText: keyEnterEmail.tr,
      enabled: false,
      labelTextStyle: textStyleTitleSmall()!
          .copyWith(fontWeight: FontWeight.w400, color: Colors.black),
      labelText: "E-mail",
      // onChanged: (value) {
      //   controller.emailString.value = value;
      // },
      inputFormatters: [EmailTextInputFormatter()],
      validator: (value) => EmailValidator.validateEmail(
          title: keyEmail.tr.toLowerCase(), value: value?.trim() ?? ""),
      inputType: TextInputType.emailAddress,
    );
  }

  Widget _imageWidget() {
    return GestureDetector(
      onTap: () => showImageDialog(
        imagePath: controller.imageFile.value.localPath ??
            controller.userResponseModel.value?.data?.profile_pic,
        isNetwork: controller.imageFile.value.localPath == null,
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
                        controller.userResponseModel.value?.data?.profile_pic ??
                            "",
                    imageHeight: height_120,
                    imageWidth: height_120,
                    includeBaseUrl: true,
                    placeHolder: userPlaceholder,
                    radiusAll: radius_100,
                  ),
          ),
          GestureDetector(
            onTap: controller.pickImage,
            child: Container(
              decoration: BoxDecoration(
                  color: isDarkMode.value ? Colors.white : AppColors.appColor,
                  borderRadius: BorderRadius.circular(margin_38)),
              child: Icon(
                Icons.edit,
                size: margin_20,
                color: isDarkMode.value ? AppColors.appColor : Colors.white,
              ).paddingAll(margin_5),
            ).paddingOnly(right: margin_3, bottom: margin_2),
          ),
        ],
      ),
    );
  }

  // Widget _AdharcardfrontWidget() {
  //   return DottedBorder(
  //     options: RoundedRectDottedBorderOptions(
  //         radius: Radius.circular(16),
  //         color: Colors.grey
  //     ),
  //     child: Center(
  //       child: GestureDetector(
  //         onTap: () => showImageDialog(
  //           imagePath: controller.AdharFrontImageFile.value.localPath ??
  //               controller.userResponseModel.value?.data?.aadharFront,
  //           isNetwork: controller.AdharFrontImageFile.value.localPath == null,
  //           includeBaseUrl: profileDataProvider.userDataModel.value?.loginType ==
  //               loginTypeNormal,
  //           placeHolder: userPlaceholder,
  //         ),
  //         child: Stack(
  //           alignment: Alignment.topRight,
  //           clipBehavior: Clip.none,
  //           children: [
  //             Container(
  //               width: Get.width*0.9,
  //               decoration: const BoxDecoration(
  //                   shape: BoxShape.rectangle, color: AppColors.whiteAppColor),
  //               child: controller.AdharFrontImageFile.value.localPath != null
  //                   ? ClipRRect(
  //                       borderRadius: BorderRadius.circular(
  //                         radius_8,
  //                       ),
  //                       child: Image.file(
  //                         File(controller.AdharFrontImageFile.value.localPath!),
  //                         height: height_100,
  //                         width: height_100,
  //                         fit: BoxFit.contain,
  //                       ),
  //                     ).paddingAll(margin_4)
  //                   : NetworkImageWidget(
  //                       imageUrl:
  //                           controller.userResponseModel.value?.data?.aadharFront ??
  //                               "",
  //                       imageHeight: height_120,
  //                       imageWidth: Get.width * 0.9,
  //                       includeBaseUrl: true,
  //                      imageFitType: BoxFit.contain,
  //                       placeHolder: userPlaceholder,
  //                       radiusAll: radius_8,
  //                     ),
  //             ),
  //             GestureDetector(
  //               onTap: controller.AdharFrontpickImage,
  //               child: Icon(
  //                 Icons.cancel_sharp,
  //                 size: margin_20,
  //                 color: isDarkMode.value ? AppColors.appColor : Colors.white,
  //               )
  //                   .paddingAll(margin_5)
  //                   .paddingOnly(right: margin_3, bottom: margin_2),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   ).marginSymmetric(horizontal: 20);
  // }
  //
  // Widget _AdharcardbackWidget() {
  //   return GestureDetector(
  //     onTap: () => showImageDialog(
  //       imagePath: controller.AdharBackImageFile.value.localPath ??
  //           controller.userResponseModel.value?.data?.aadharBack,
  //       isNetwork: controller.AdharBackImageFile.value.localPath == null,
  //       includeBaseUrl: profileDataProvider.userDataModel.value?.loginType ==
  //           loginTypeNormal,
  //       placeHolder: userPlaceholder,
  //     ),
  //     child: Stack(
  //       alignment: Alignment.topRight,
  //       clipBehavior: Clip.none,
  //       children: [
  //         Container(
  //           decoration: const BoxDecoration(
  //               shape: BoxShape.rectangle, color: AppColors.whiteAppColor),
  //           child: controller.AdharBackImageFile.value.localPath != null
  //               ? ClipRRect(
  //             borderRadius: BorderRadius.circular(
  //               radius_8,
  //             ),
  //             child: Image.file(
  //               File(controller.AdharBackImageFile.value.localPath!),
  //               height: height_100,
  //               width: height_100,
  //               fit: BoxFit.contain,
  //             ),
  //           ).paddingAll(margin_4)
  //               : NetworkImageWidget(
  //             imageUrl:
  //             controller.userResponseModel.value?.data?.aadharBack ??
  //                 "",
  //             imageHeight: height_120,
  //             imageWidth: Get.width * 0.9,
  //             includeBaseUrl: true,
  //             imageFitType: BoxFit.contain,
  //             placeHolder: userPlaceholder,
  //             radiusAll: radius_8,
  //           ),
  //         ),
  //         GestureDetector(
  //           onTap: controller.pickImage,
  //           child: Icon(
  //             Icons.cancel_sharp,
  //             size: margin_20,
  //             color: isDarkMode.value ? AppColors.appColor : Colors.white,
  //           )
  //               .paddingAll(margin_5)
  //               .paddingOnly(right: margin_3, bottom: margin_2),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _dlfrontWidget() {
  //   return GestureDetector(
  //     onTap: () => showImageDialog(
  //       imagePath: controller.imageFile.value.localPath ??
  //           controller.userResponseModel.value?.data?.profile_pic,
  //       isNetwork: controller.imageFile.value.localPath == null,
  //       includeBaseUrl: profileDataProvider.userDataModel.value?.loginType ==
  //           loginTypeNormal,
  //       placeHolder: userPlaceholder,
  //     ),
  //     child: Stack(
  //       alignment: Alignment.bottomRight,
  //       clipBehavior: Clip.none,
  //       children: [
  //         Container(
  //           decoration: const BoxDecoration(
  //               shape: BoxShape.circle, color: AppColors.appGreyColorDark),
  //           child: controller.imageFile.value.localPath != null
  //               ? ClipRRect(
  //                   borderRadius: BorderRadius.circular(
  //                     radius_100,
  //                   ),
  //                   child: Image.file(
  //                     File(controller.imageFile.value.localPath!),
  //                     height: height_100,
  //                     width: height_100,
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ).paddingAll(margin_4)
  //               : NetworkImageWidget(
  //                   imageUrl:
  //                       controller.userResponseModel.value?.data?.profile_pic ??
  //                           "",
  //                   imageHeight: height_120,
  //                   imageWidth: height_120,
  //                   includeBaseUrl: true,
  //                   placeHolder: userPlaceholder,
  //                   radiusAll: radius_100,
  //                 ),
  //         ),
  //         GestureDetector(
  //           onTap: controller.pickImage,
  //           child: Container(
  //             decoration: BoxDecoration(
  //                 color: isDarkMode.value ? Colors.white : AppColors.appColor,
  //                 borderRadius: BorderRadius.circular(margin_38)),
  //             child: Icon(
  //               Icons.edit,
  //               size: margin_20,
  //               color: isDarkMode.value ? AppColors.appColor : Colors.white,
  //             ).paddingAll(margin_5),
  //           ).paddingOnly(right: margin_3, bottom: margin_2),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _dlbackWidget() {
  //   return GestureDetector(
  //     onTap: () => showImageDialog(
  //       imagePath: controller.imageFile.value.localPath ??
  //           controller.userResponseModel.value?.data?.profile_pic,
  //       isNetwork: controller.imageFile.value.localPath == null,
  //       includeBaseUrl: profileDataProvider.userDataModel.value?.loginType ==
  //           loginTypeNormal,
  //       placeHolder: userPlaceholder,
  //     ),
  //     child: Stack(
  //       alignment: Alignment.bottomRight,
  //       clipBehavior: Clip.none,
  //       children: [
  //         Container(
  //           decoration: const BoxDecoration(
  //               shape: BoxShape.circle, color: AppColors.appGreyColorDark),
  //           child: controller.imageFile.value.localPath != null
  //               ? ClipRRect(
  //                   borderRadius: BorderRadius.circular(
  //                     radius_100,
  //                   ),
  //                   child: Image.file(
  //                     File(controller.imageFile.value.localPath!),
  //                     height: height_100,
  //                     width: height_100,
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ).paddingAll(margin_4)
  //               : NetworkImageWidget(
  //                   imageUrl:
  //                       controller.userResponseModel.value?.data?.profile_pic ??
  //                           "",
  //                   imageHeight: height_120,
  //                   imageWidth: height_120,
  //                   includeBaseUrl: true,
  //                   placeHolder: userPlaceholder,
  //                   radiusAll: radius_100,
  //                 ),
  //         ),
  //         GestureDetector(
  //           onTap: controller.pickImage,
  //           child: Container(
  //             decoration: BoxDecoration(
  //                 color: isDarkMode.value ? Colors.white : AppColors.appColor,
  //                 borderRadius: BorderRadius.circular(margin_38)),
  //             child: Icon(
  //               Icons.edit,
  //               size: margin_20,
  //               color: isDarkMode.value ? AppColors.appColor : Colors.white,
  //             ).paddingAll(margin_5),
  //           ).paddingOnly(right: margin_3, bottom: margin_2),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buttonWidget() {
    return CustomMaterialButton(
      bgColor: Color.fromRGBO(221, 78, 75, 1),
      textColor: Colors.white,
      borderRadius: 30,
      onTap: () async{
        var path="";
        if(controller.imageFile.value.localPath!=null){
           path = (await controller.callUploadMedia(File(controller.imageFile.value.localPath ?? '')))?.file_name??"";
        }

        // Check if user is a driver
        bool isDriver =controller.userResponseModel.value?.data?.role  == "DRIVER";
        
        if (isDriver) {
          // For drivers, navigate to update document screen
          Get.offNamed(AppRoutes.updateDocumentRoute, arguments: {
            "firstname": controller.stateController.text,
            "lastname": controller.cityController.text,
            "countryCode": controller.selectedCountry.value.dialCode,
            "phonenumber": controller.numberController.text,
            "Profile": path
          });
        } else {
          // For regular users, directly update profile
          Map<String, dynamic> requestModel = AuthRequestModel.editProfile(
            firstName: controller.stateController.text,
            lastName: controller.cityController.text,
            countryCode: controller.selectedCountry.value.dialCode,
            phoneNumber: controller.numberController.text,
            profilePic: path,
          );
          controller.handleSubmit(requestModel);
        }
      },
      buttonText: "Next",
    ).marginSymmetric(horizontal: 20, vertical: 80);
  }

  // Widget _routeCards() {
  //   return Column(
  //     children: [
  //
  //
  //       _singleTabWidget(keySignOut.tr, onTap: () {
  //         showProfileActionDialog(
  //             title: keySignOut.tr,
  //             subtitle: keySignOutDes.tr,
  //             actionText: keyYes.tr,
  //             cancelText: keyNo.tr,
  //             imagePath: icSignOut,
  //
  //             onTap: () {
  //               Get.back();
  //               controller.logout();
  //             },
  //             color: AppColors.appColor);
  //       }, titleImage: icSignOut)
  //           .paddingOnly(bottom: margin_10),
  //     ],
  //   );
  // }

  // Widget _singleTabWidget(String title,
  //     {Color? widgetColor,
  //     VoidCallback? onTap,
  //     String? titleImage,
  //     bool capitalize = true,
  //     double? imageHeight,
  //     double? imageWidth,
  //     isIconColor = false}) {
  //   return GestureDetector(
  //     behavior: HitTestBehavior.translucent,
  //     onTap: onTap,
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         AssetSVGWidget(titleImage ?? '',
  //                 color: isIconColor
  //                     ? AppColors.appColor
  //                     : null,
  //                 imageHeight: imageHeight ?? height_33,
  //                 imageWidth: imageWidth ?? height_33)
  //             .paddingOnly(right: margin_8),
  //         Expanded(
  //           child: TextView(
  //             text: capitalize ? title.tr.capitalize ?? '' : title.tr ?? '',
  //             textStyle:
  //                 textStyleTitleMedium()!.copyWith(color: widgetColor ?? null),
  //             textAlign: TextAlign.start,
  //             maxLines: 1,
  //           ),
  //         ),
  //
  //       ],
  //     ),
  //   );
  // }

  Widget _dividerWidget() {
    return Divider(
        height: margin_25,
        color: isDarkMode.value
            ? AppColors.whiteLight
            : AppColors.appGreyColorDark);
  }
}
