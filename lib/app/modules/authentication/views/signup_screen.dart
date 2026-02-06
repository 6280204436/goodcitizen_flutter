import 'package:good_citizen/app/core/utils/localizations/localization_controller.dart';
import 'package:good_citizen/app/modules/authentication/controllers/select_signup_controller.dart';
import 'package:good_citizen/app/modules/authentication/controllers/sign_up_controller.dart';
import 'package:good_citizen/app/modules/authentication/widgets/language_selection_widget.dart';
import '../../../common_data.dart';
import '../../../core/utils/email_formatter.dart';
import '../../../core/utils/show_bottom_sheet.dart';
import '../../../core/widgets/drop_down_text_widget.dart';
import '../../../core/widgets/network_image_widget.dart';
import '../../../core/widgets/show_dialog.dart';
import '../../../export.dart';
import '../controllers/login_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupScreen extends GetView<SignUpController> {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _backGroundImage(),
    );
  }

  Widget _backGroundImage() => SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          width: Get.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color.fromRGBO(200, 41, 39, 1),
                Color.fromRGBO(221, 78, 75, 1),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Get.height * 0.2,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white)
                      .marginSymmetric(horizontal: 20),
                ),
              ),
              Container(
                width: Get.width,
                height: Get.height * 0.8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextView(
                        text: "Let’s Get Started",
                        maxLines: 2,
                        textStyle: textStyleDisplayMedium()!.copyWith(
                          color: const Color.fromRGBO(221, 78, 75, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ).marginOnly(
                          top: margin_35, left: margin_20, right: margin_20),
                      TextView(
                        text:
                            "Enter your details below to complete your account sign-up.",
                        maxLines: 2,
                        textStyle: textStyleDisplayMedium()!.copyWith(
                          color: const Color.fromRGBO(221, 78, 75, 1),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ).marginOnly(
                          top: margin_4, left: margin_20, right: margin_20),
                      // _disclaimerWidget(), // Added disclaimer
                      _formWidget(),

                      Row(
                        children: [
                          Obx(() => GestureDetector(
                              onTap: () {
                                controller.AgreeConditions.value =
                                    !controller.AgreeConditions.value;
                                controller.AgreeConditions.refresh();
                              },
                              child: Icon(controller.AgreeConditions.value
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank))),
                          Flexible(child: _termsRichtext()),
                        ],
                      ).marginSymmetric(horizontal: 20),
                      _buttonWidget().marginOnly(bottom: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  // Widget _disclaimerWidget() {
  //   return TextView(
  //     text:
  //         "This app uses location data to provide emergency services. By signing up, you agree that your location may be shared with emergency responders to assist you in case of distress. Ensure emergency services in your region can receive this data.",
  //     maxLines: 4,
  //     textStyle: textStyleBodySmall()!.copyWith(
  //       color: Colors.redAccent,
  //       fontSize: 12,
  //       fontWeight: FontWeight.w400,
  //     ),
  //   ).marginOnly(top: margin_10, left: margin_20, right: margin_20);
  // }

  Widget _formWidget() {
    return _fieldWidgets();
  }

  Widget _fieldWidgets() {
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          Obx(() => _imageWidget()).marginSymmetric(vertical: 30),
          _firstname().marginSymmetric(horizontal: 20),
          _lastname().marginSymmetric(horizontal: 20, vertical: 20),
          _emailField().paddingOnly(
              bottom: margin_22, left: margin_20, right: margin_20),
          _phoneField(),
          _countryDropDown().marginSymmetric(horizontal: 20, vertical: 20),
          _passwordTextField().paddingOnly(
              bottom: margin_22, left: margin_20, right: margin_20),
          _confirmpasswordTextField().paddingOnly(
              bottom: margin_22, left: margin_20, right: margin_20),
        ],
      ),
    );
  }

  TextFieldWidget _emailField() {
    return TextFieldWidget(
      controller: controller.emailController,
      textInputAction: TextInputAction.done,
      focusNode: controller.emailFocusNode,
      hintText: keyEnterEmail.tr,
      labelTextStyle: textStyleTitleSmall()!
          .copyWith(fontWeight: FontWeight.w400, color: Colors.black),
      labelText: "E-mail",
      inputFormatters: [EmailTextInputFormatter()],
      validator: (value) => EmailValidator.validateEmail(
        title: keyEmail.tr.toLowerCase(),
        value: value?.trim() ?? "",
      ),
      inputType: TextInputType.emailAddress,
    );
  }

  TextFieldWidget _firstname() {
    return TextFieldWidget(
      controller: controller.firstnameController,
      textInputAction: TextInputAction.done,
      focusNode: controller.firstnameNode,
      hintText: "Enter your first name",
      labelTextStyle: textStyleTitleSmall()!
          .copyWith(fontWeight: FontWeight.w400, color: Colors.black),
      labelText: "First Name",
      inputFormatters: [NameTextInputFormatter()],
      validator: (value) => NameValidator.validateName(
        title: "First Name".toLowerCase(),
        value: value?.trim() ?? '',
      ),
      inputType: TextInputType.name,
    );
  }

  Widget _imageWidget() {
    return GestureDetector(
      onTap: () => showImageDialog(
        imagePath: controller.imageFile.value.localPath ??
            profileDataProvider.userDataModel.value?.image ??
            '',
        isNetwork: controller.imageFile.value.localPath == null,
        includeBaseUrl: profileDataProvider.userDataModel.value?.loginType ==
            loginTypeNormal,
        placeHolder: userPlaceholder,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: controller.pickImage,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.appGreyColorDark,
              ),
              child: controller.imageFile.value.localPath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(radius_100),
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
          ),
          GestureDetector(
            onTap: controller.pickImage,
            child: TextView(
              text: "Add Profile Image",
              maxLines: 1,
              textStyle: textStyleDisplayMedium()!.copyWith(
                color: const Color.fromRGBO(221, 78, 75, 1),
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ).marginOnly(top: margin_10, left: margin_20, right: margin_20),
          ),
        ],
      ),
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
    ).marginSymmetric(horizontal: 20);
  }

  Widget _countryDropDown() {
    return Obx(
      () => Container(
        child: DropDownTextWidget(
          tvHeading: "Gender",
          focusNode: controller.countryFocusNode,
          styleheading: const TextStyle(
            color: AppColors.greyColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          hint: "Select",
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Color.fromRGBO(130, 130, 130, 1),
            size: 20,
          ),
          items: const <String>["Male", "Female", "Others"],
          dropdownType: true,
          selectedValue: controller.gender.value,
          onFieldSubmitted: (value) {
            controller.gender.value = value;
            print("Selected Gender: ${controller.gender.value}");
            FocusScope.of(Get.context!)
                .requestFocus(controller.countryFocusNode);
          },
        ),
      ),
    );
  }

  TextFieldWidget _lastname() {
    return TextFieldWidget(
      controller: controller.lastnameController,
      textInputAction: TextInputAction.done,
      focusNode: controller.lastnameNode,
      hintText: "Enter your last name",
      labelTextStyle: textStyleTitleSmall()!
          .copyWith(fontWeight: FontWeight.w400, color: Colors.black),
      labelText: "Last Name",
      inputFormatters: [NameTextInputFormatter()],
      validator: (value) => NameValidator.validateName(
        title: "Last Name".toLowerCase(),
        value: value?.trim() ?? '',
      ),
      inputType: TextInputType.name,
    );
  }

  Widget _passwordTextField() => Obx(
        () => TextFieldWidget(
          controller: controller.passwordController,
          textInputAction: TextInputAction.done,
          focusNode: controller.passwordFocusNode,
          obscureText: controller.isShow.value,
          suffixIcon: IconButton(
            onPressed: () {
              controller.isShow.value = !controller.isShow.value;
            },
            icon: Icon(
              controller.isShow.value ? Icons.visibility : Icons.visibility_off,
            ),
          ),
          hintText: "Enter your password",
          labelTextStyle: textStyleTitleSmall()!
              .copyWith(fontWeight: FontWeight.w400, color: Colors.black),
          labelText: "Password",
          validator: (value) => PasswordFormValidator.validatePassword(
            title: keyPassword.tr.toLowerCase(),
            value: value?.trim() ?? "",
          ),
          inputType: TextInputType.text,
        ).paddingOnly(bottom: margin_12),
      );

  Widget _confirmpasswordTextField() => Obx(
        () => TextFieldWidget(
          controller: controller.confimPasswordController,
          textInputAction: TextInputAction.done,
          focusNode: controller.confirmFocusNode,
          obscureText: controller.isShowpass.value,
          suffixIcon: IconButton(
            onPressed: () {
              controller.isShowpass.value = !controller.isShowpass.value;
            },
            icon: Icon(
              controller.isShowpass.value
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
          ),
          hintText: "Enter your confirm password",
          labelTextStyle: textStyleTitleSmall()!
              .copyWith(fontWeight: FontWeight.w400, color: Colors.black),
          labelText: "Confirm Password",
          validator: (value) =>
              PasswordFormValidator.validateConfirmPasswordMatch(
            title: keyPassword.tr.toLowerCase(),
            value: value?.trim() ?? "",
            password: controller.passwordController.text,
          ),
          inputType: TextInputType.text,
        ).paddingOnly(bottom: margin_12),
      );

  Widget _buttonWidget() {
    return CustomMaterialButton(
      bgColor: const Color.fromRGBO(221, 78, 75, 1),
      textColor: Colors.white,
      borderRadius: 30,
      onTap: () {
        if (controller.imageFile.value.localPath == null) {
          showSnackBar(message: "Profile picture is required");
        } else {
          controller.validate();
        }
      },
      buttonText: keySignUp.tr,
    ).marginSymmetric(horizontal: 20, vertical: 20);
  }

  RichText _termsRichtext() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'By using this app you are agreeing to our ',
        style: textStyleBodyMedium()!.copyWith(
          fontWeight: FontWeight.w400,
          color: AppColors.blackColor,
        ),
        children: [
          TextSpan(
            text: 'Terms & Conditions',
            style: textStyleBodyMedium()!.copyWith(
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(221, 78, 75, 1),
              decoration: TextDecoration.underline,
              decorationColor: const Color.fromRGBO(221, 78, 75, 1),
              decorationThickness: 2.0,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed(AppRoutes.staticPageRoute,
                    arguments: {"from": "Terms"});
              },
          ),
          TextSpan(
            text: ', ',
            style: textStyleBodyMedium()!.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.blackColor,
            ),
          ),
          TextSpan(
            text: 'EULA',
            style: textStyleBodyMedium()!.copyWith(
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(221, 78, 75, 1),
              decoration: TextDecoration.underline,
              decorationColor: const Color.fromRGBO(221, 78, 75, 1),
              decorationThickness: 2.0,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed(AppRoutes.staticPageRoute,
                    arguments: {"from": "EULA"});
              },
          ),
          TextSpan(
            text: ' and ',
            style: textStyleBodyMedium()!.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.blackColor,
            ),
          ),
          TextSpan(
            text: 'Privacy Policy',
            style: textStyleBodyMedium()!.copyWith(
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(221, 78, 75, 1),
              decoration: TextDecoration.underline,
              decorationColor: const Color.fromRGBO(221, 78, 75, 1),
              decorationThickness: 2.0,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed(AppRoutes.staticPageRoute,
                    arguments: {"from": "Privacy"});
              },
          ),
        ],
      ),
      maxLines: 3,
    );
  }
}
