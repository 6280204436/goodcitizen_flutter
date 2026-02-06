import 'package:good_citizen/app/core/utils/localizations/localization_controller.dart';
import 'package:good_citizen/app/modules/authentication/controllers/select_signup_controller.dart';
import 'package:good_citizen/app/modules/authentication/controllers/sign_up_controller.dart';
import 'package:good_citizen/app/modules/authentication/widgets/language_selection_widget.dart';

import '../../../common_data.dart';
import '../../../core/utils/email_formatter.dart';
import '../../../core/utils/show_bottom_sheet.dart';
import '../../../export.dart';
import '../controllers/login_controller.dart';

class LogInScreen extends GetView<LoginController> {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        child: _bodyWidget(context, isLandscape),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context, bool isLandscape) {
    return _backGroundImage(context, isLandscape);
  }

  Widget _backGroundImage(BuildContext context, bool isLandscape) =>
      SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Color.fromRGBO(200, 41, 39, 1),
              Color.fromRGBO(221, 78, 75, 1)
            ],
          )),
          child: isLandscape
              ? _landscapeLayout(context)
              : _portraitLayout(context),
        ),
      );

  Widget _portraitLayout(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: Get.height * 0.16),
          Container(
            height: Get.height * 0.84,
            width: Get.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView(
                  text: "Welcome Back!",
                  maxLines: 1,
                  textStyle: textStyleDisplayMedium()!.copyWith(
                      color: Color.fromRGBO(221, 78, 75, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ).marginOnly(top: margin_35, left: margin_15),
                TextView(
                  text: "Use your credentials to login below",
                  maxLines: 1,
                  textStyle: textStyleDisplayMedium()!.copyWith(
                      color: Color.fromRGBO(221, 78, 75, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.w300),
                ).marginOnly(top: margin_4, left: margin_15),
                _formWidget(isLandscape: false),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.forgetPassword);
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextView(
                      text: "Forgot password?",
                      maxLines: 1,
                      textStyle: textStyleDisplayMedium()!.copyWith(
                          color: Color.fromRGBO(221, 78, 75, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                    ).marginOnly(top: margin_4, left: margin_20),
                  ).marginSymmetric(horizontal: 20),
                ),
                SizedBox(height: margin_180),
                Row(
                  children: [
                    Obx(() => GestureDetector(
                        onTap: () {
                          controller.AgreeConditions.value =
                              !controller.AgreeConditions.value;
                          controller.AgreeConditions.refresh();
                        },
                        child: Icon(
                          controller.AgreeConditions.value
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: Colors.black,
                          size: 30,
                        ))),
                    Flexible(child: _termsRichtext()),
                  ],
                ).marginSymmetric(horizontal: 20),
                _buttonWidget(isLandscape: false),
                Center(child: _richTextWidget()).marginOnly(bottom: 30),
              ],
            ),
          ),
        ],
      );

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

  Widget _landscapeLayout(BuildContext context) => Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.center,
              child: TextView(
                text: "LOGIN".toUpperCase(),
                maxLines: 1,
                textStyle: textStyleDisplayMedium()!.copyWith(
                    color: AppColors.whiteAppColor.withOpacity(0.1),
                    fontSize: 40,
                    fontWeight: FontWeight.w600),
              ).marginOnly(left: margin_20),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(20))),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(
                      text: "Welcome Back!",
                      maxLines: 1,
                      textStyle: textStyleDisplayMedium()!.copyWith(
                          color: Color.fromRGBO(221, 78, 75, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ).marginOnly(top: margin_15, left: margin_10),
                    TextView(
                      text: "Use your credentials to login below",
                      maxLines: 1,
                      textStyle: textStyleDisplayMedium()!.copyWith(
                          color: Color.fromRGBO(221, 78, 75, 1),
                          fontSize: 10,
                          fontWeight: FontWeight.w300),
                    ).marginOnly(left: margin_10),
                    _formWidget(isLandscape: true),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.forgetPassword);
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: TextView(
                          text: "Forgot password?",
                          maxLines: 1,
                          textStyle: textStyleDisplayMedium()!.copyWith(
                              color: Color.fromRGBO(221, 78, 75, 1),
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ).marginOnly(top: margin_4, left: margin_15),
                      ).marginSymmetric(horizontal: 15),
                    ),
                    SizedBox(height: margin_15),
                    _buttonWidget(isLandscape: true),
                    Center(child: _richTextWidget()).marginOnly(bottom: 20),
                  ],
                ),
              ).marginOnly(right: margin_15),
            ),
          ),
        ],
      );

  Widget _formWidget({required bool isLandscape}) {
    return _fieldWidgets(isLandscape: isLandscape);
  }

  Widget _fieldWidgets({required bool isLandscape}) {
    return Form(
      key: controller.loginFormKey,
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: isLandscape ? Get.width * 0.5 : Get.width * 0.9),
            child: _emailField(isLandscape: isLandscape),
          ).paddingOnly(
              bottom: margin_15,
              left: isLandscape ? margin_15 : margin_15,
              right: isLandscape ? margin_15 : margin_15,
              top: isLandscape ? margin_15 : margin_15),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: isLandscape ? Get.width * 0.5 : Get.width * 0.9),
            child: _passwordTextField(isLandscape: isLandscape),
          ).paddingOnly(
              bottom: isLandscape ? margin_10 : margin_15,
              left: isLandscape ? margin_15 : margin_15,
              right: isLandscape ? margin_15 : margin_15),
        ],
      ),
    );
  }

  TextFieldWidget _emailField({required bool isLandscape}) {
    return TextFieldWidget(
      controller: controller.emailController,
      textInputAction: TextInputAction.next,
      focusNode: controller.emailFocusNode,
      hintText: keyEnterEmail.tr,
      labelTextStyle: textStyleTitleSmall()!.copyWith(
          fontWeight: FontWeight.w400,
          color: Colors.black,
          fontSize: isLandscape ? 12 : 14),
      labelText: "E-mail",
      inputFormatters: [EmailTextInputFormatter()],
      validator: (value) => EmailValidator.validateEmail(
          title: keyEmail.tr.toLowerCase(), value: value?.trim() ?? ""),
      inputType: TextInputType.emailAddress,
      // contentPadding: EdgeInsets.symmetric(vertical: isLandscape ? 8 : 12, horizontal: 10),
    );
  }

  Widget _passwordTextField({required bool isLandscape}) => Obx(
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
              size: isLandscape ? 18 : 24,
            ),
          ),
          hintText: "Enter your password",
          labelTextStyle: textStyleTitleSmall()!.copyWith(
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontSize: isLandscape ? 12 : 14),
          labelText: "Password",
          validator: (value) => PasswordFormValidator.validatePassword(
              title: keyPassword.tr.toLowerCase(), value: value?.trim() ?? ""),
          inputType: TextInputType.text,
          // contentPadding: EdgeInsets.symmetric(vertical: isLandscape ? 8 : 12, horizontal: 10),
        ).paddingOnly(bottom: isLandscape ? margin_10 : margin_12),
      );

  Widget _buttonWidget({required bool isLandscape}) {
    return SizedBox(
      width: isLandscape ? Get.width * 0.5 : Get.width * 0.9,
      height: isLandscape ? 40 : 50,
      child: CustomMaterialButton(
        bgColor: Color.fromRGBO(221, 78, 75, 1),
        textColor: Colors.white,
        borderRadius: 30,
        onTap: () {
          controller.validate();
        },
        buttonText: keyLogIn.tr,
      ),
    ).marginSymmetric(
        horizontal: isLandscape ? 15 : 20, vertical: isLandscape ? 15 : 10);
  }

  RichText _richTextWidget() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Don’t have an account? ',
        style: textStyleBodyMedium()!.copyWith(
          fontWeight: FontWeight.w400,
          color: AppColors.blackColor,
          fontSize: 12,
        ),
        children: [
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: GestureDetector(
                onTap: () {
                  if (Get.isRegistered<SignUpController>()) {
                    Get.back();
                  } else {
                    Get.toNamed(AppRoutes.selectSignUpRoute);
                  }
                },
                child: Text(
                  'Signup',
                  style: textStyleBodyMedium()!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(221, 78, 75, 1),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      maxLines: 3,
    );
  }
}
