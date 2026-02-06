import 'package:good_citizen/app/core/utils/localizations/localization_controller.dart';
import 'package:good_citizen/app/modules/authentication/controllers/select_signup_controller.dart';
import 'package:good_citizen/app/modules/authentication/widgets/language_selection_widget.dart';

import '../../../common_data.dart';
import '../../../core/utils/show_bottom_sheet.dart';
import '../../../export.dart';
import '../controllers/login_controller.dart';

class SelectSignupScreen extends GetView<SelectSignupController> {
  const SelectSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      body: _bodyWidget(context, isLandscape),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: Get.height * 0.2,
            // child: TextView(
            //   text: "Select".toUpperCase(),
            //   maxLines: 1,
            //   textStyle: textStyleDisplayMedium()!.copyWith(
            //       color: AppColors.whiteAppColor.withOpacity(0.1),
            //       fontSize: 70,
            //       fontWeight: FontWeight.w600),
            // ).marginOnly(top: Get.height * 0.12),
          ),
          Container(
            width: Get.width,
            height: Get.height * 0.8,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextView(
                  text: "Select Your Account Type",
                  maxLines: 1,
                  textStyle: textStyleDisplayMedium()!.copyWith(
                      color: Color.fromRGBO(221, 78, 75, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ).marginOnly(top: margin_35, left: margin_20),
                TextView(
                  text: "Please select an option to proceed",
                  maxLines: 1,
                  textStyle: textStyleDisplayMedium()!.copyWith(
                      color: Color.fromRGBO(221, 78, 75, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.w300),
                ).marginOnly(top: margin_4, left: margin_20),
                _accountTypeSelection(),
                Expanded(child: SizedBox()),
                _buttonWidget(),
                Center(child: _richTextWidget()).marginOnly(bottom: 50),
              ],
            ),
          ),
        ],
      );

  Widget _landscapeLayout(BuildContext context) => Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.center,
              child: TextView(
                text: "Select".toUpperCase(),
                maxLines: 1,
                textStyle: textStyleDisplayMedium()!.copyWith(
                    color: AppColors.whiteAppColor.withOpacity(0.1),
                    fontSize: 50,
                    fontWeight: FontWeight.w600),
              ).marginOnly(left: margin_20),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              height: Get.height,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextView(
                    text: "Select Your Account Type",
                    maxLines: 1,
                    textStyle: textStyleDisplayMedium()!.copyWith(
                        color: Color.fromRGBO(221, 78, 75, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ).marginOnly(top: margin_20, left: margin_20),
                  TextView(
                    text: "Please select an option to proceed",
                    maxLines: 1,
                    textStyle: textStyleDisplayMedium()!.copyWith(
                        color: Color.fromRGBO(221, 78, 75, 1),
                        fontSize: 12,
                        fontWeight: FontWeight.w300),
                  ).marginOnly(top: margin_4, left: margin_20),
                  _accountTypeSelection(),
                  Expanded(child: SizedBox()),
                  _buttonWidget(),
                  Center(child: _richTextWidget()).marginOnly(bottom: 30),
                ],
              ).marginOnly(right: margin_20),
            ),
          ),
        ],
      );

  Widget _accountTypeSelection() => Column(
        children: [
          Obx(
            () => GestureDetector(
              onTap: () {
                controller.Selectsignup.value = "user";
                controller.update();
              },
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(245, 245, 245, 1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: controller.Selectsignup.value == "user"
                            ? Color.fromRGBO(221, 78, 75, 1)
                            : Color.fromRGBO(245, 245, 245, 1))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextView(
                      text: "Signup as User",
                      maxLines: 1,
                      textStyle: textStyleDisplayMedium()!.copyWith(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                    ).marginSymmetric(
                        vertical: margin_13, horizontal: margin_20),
                    Icon(Icons.check_circle,
                            color: controller.Selectsignup.value == "user"
                                ? Color.fromRGBO(221, 78, 75, 1)
                                : Color.fromRGBO(245, 245, 245, 1))
                        .marginSymmetric(horizontal: margin_20),
                  ],
                ),
              ).marginSymmetric(horizontal: 20, vertical: 20),
            ),
          ),
          Obx(
            () => GestureDetector(
              onTap: () {
                controller.Selectsignup.value = "driver";
                controller.update();
              },
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(245, 245, 245, 1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: controller.Selectsignup.value == "driver"
                            ? Color.fromRGBO(221, 78, 75, 1)
                            : Color.fromRGBO(245, 245, 245, 1))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextView(
                      text: "Signup as Driver",
                      maxLines: 1,
                      textStyle: textStyleDisplayMedium()!.copyWith(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                    ).marginSymmetric(
                        vertical: margin_13, horizontal: margin_20),
                    Icon(Icons.check_circle,
                            color: controller.Selectsignup.value == "driver"
                                ? Color.fromRGBO(221, 78, 75, 1)
                                : Color.fromRGBO(245, 245, 245, 1))
                        .marginSymmetric(horizontal: margin_20),
                  ],
                ),
              ).marginSymmetric(horizontal: 20),
            ),
          ),
        ],
      );

  Widget _buttonWidget() {
    return CustomMaterialButton(
      bgColor: Color.fromRGBO(221, 78, 75, 1),
      textColor: Colors.white,
      borderRadius: 30,
      onTap: () {
        Get.toNamed(AppRoutes.signupRoutes,
            arguments: {"role": controller.Selectsignup.value?.toUpperCase()});
      },
      buttonText: keyContinue.tr,
    ).marginSymmetric(horizontal: 20, vertical: 20);
  }

  RichText _richTextWidget() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Already have an account? ',
        style: textStyleBodyMedium()!.copyWith(
          fontWeight: FontWeight.w400,
          color: AppColors.blackColor,
        ),
        children: [
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.loginRoute,
                      arguments: {"role": controller.Selectsignup.value});
                },
                child: Text(
                  'Login',
                  style: textStyleBodyMedium()!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(221, 78, 75, 1),
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
