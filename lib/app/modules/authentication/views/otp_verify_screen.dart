import 'package:good_citizen/app/core/utils/common_methods.dart';
import 'package:good_citizen/app/export.dart';

import '../controllers/otp_verify_controller.dart';

class OtpVerificationScreen extends GetView<OtpVerificationController> {
  OtpVerificationScreen({super.key}) {
    if (!Get.isRegistered<OtpVerificationController>()) {
      Get.put(OtpVerificationController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _bodyWidget()),
    );
  }

  AppBar _appBarWidget() {
    return customAppBar();
  }

  Widget _bodyWidget() {
    return _backGroundImage();
  }

  Widget _backGroundImage() => SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          width: Get.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.bottomLeft, // Start from top
            end: Alignment.topRight,
            colors: [
              Color.fromRGBO(200, 41, 39, 1),
              Color.fromRGBO(221, 78, 75, 1)
            ],
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height:Get.height*0.2,
                child: GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back_ios).marginSymmetric(horizontal: 20)),
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
                    _formWidget(),
                    Expanded(child: SizedBox()),
                  ],
                ).marginSymmetric(horizontal: 20, vertical: 20),
              ),
            ],
          ),
        ),
      );

  //
  // SafeArea(
  // child: _formWidget().paddingSymmetric(horizontal: margin_15),
  // );
  Widget _formWidget() {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleDescriptionWidget().paddingOnly(bottom: margin_20),
        _pinPutWidget().paddingOnly(bottom: margin_20),
        _verifyButton().paddingOnly(bottom: margin_20),
        // Visibility(
        //     visible: controller.isForEmail == false, child: _yourOtpWidget()),
        Center(child: _resendWidget())
            .paddingOnly(top: controller.isForEmail == false ? margin_15 : 0),
      ],
    ));
  }

  Widget _pinPutWidget() {
    final defaultPinTheme = PinTheme(
      width: height_40,
      height: height_40,
      textStyle: textStyleTitleSmall()!.copyWith(fontSize: font_22),
      decoration: BoxDecoration(
        color:  AppColors.appGreyColor,
        borderRadius: BorderRadius.circular(radius_6),
      ),
    );

    return Form(
      key: controller.formKey,
      child: Pinput(
        length: 6,
        controller: controller.otpController,
        focusNode: controller.pinFocusNode,
        // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
        // listenForMultipleSmsOnAndroid: true,
        defaultPinTheme: defaultPinTheme,
        forceErrorState: controller.forceErrorState.value,
        separatorBuilder: (index) => SizedBox(width: width_8),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          final data = FieldChecker.otpValidator(value: value);
          if (data != null) {
            controller.forceErrorState.value = true;
          }
          return data;
        },
        hapticFeedbackType: HapticFeedbackType.lightImpact,
        onCompleted: (pin) {
          debugPrint('onCompleted: $pin');
        },
        onChanged: (value) {
          controller.forceErrorState.value = false;
          debugPrint('onChanged: $value');
        },
        cursor: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: height_1,
              height: height_30,
              color: darkGreyColor.withOpacity(0.8),
            ),
          ],
        ),
        focusedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(color: AppColors.appColor),
          ),
        ),
        submittedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: AppColors.appColor.withOpacity(0.8)),
        )),
        errorPinTheme: defaultPinTheme.copyBorderWith(
          border: Border.all(color: AppColors.redColor.withOpacity(0.8)),
        ),
      ),
    );
  }

  Column _titleDescriptionWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

    TextView(
    text: "OTP Verification",
      maxLines: 1,
      textStyle: textStyleDisplayMedium()!.copyWith(color:Color.fromRGBO(221,78,75, 1),fontSize:18,fontWeight:FontWeight.w600 ),
    ).marginOnly(top:margin_10,bottom: margin_10),
        RichText(
            maxLines: 5,
            textAlign: TextAlign.start,
            text: TextSpan(
                text: '${keyEnterEmailCode.tr} ',
                style: textStyleTitleSmall()!
                    .copyWith(color: AppColors.textGreyColor),
                children: [
                  TextSpan(
                      text: "${controller.email}",
                      style: textStyleBodyMedium()!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(221, 78, 75, 1)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed(AppRoutes.staticPageRoute,
                              arguments: {argType: staticPagePrivacy});
                        }),
                ]))
      ],
    );
  }

  // TextSpan _editButton() {
  //   return TextSpan(
  //       text: keyEdit.tr,
  //       style: textStyleTitleSmall()!
  //           .copyWith(color: AppColors.blackColor, fontWeight: FontWeight.w500),
  //       recognizer: TapGestureRecognizer()
  //         ..onTap = () {
  //           Get.back();
  //         });
  // }

  CustomMaterialButton _verifyButton() {
    return CustomMaterialButton(
      borderRadius:30,
      bgColor: Color.fromRGBO(221, 78, 75,1),
      onTap: controller.validate,
      isLoading: controller.isLoading.value,
      buttonText: keyVerify,
    );
  }

  Widget _resendWidget() {
    return controller.isTimerStarted.value
        ? RichText(
            text: TextSpan(
              text: '${keyResendCodeIn.tr} ',
              style: textStyleTitleSmall()!
                  .copyWith(color: AppColors.textGreyColor),
              children: <TextSpan>[
                TextSpan(
                  text: (controller.leftDuration.value < 10)
                      ? "00:0${controller.leftDuration.value}"
                      : "00:${controller.leftDuration.value}",
                  style: textStyleTitleSmall()!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                      onTap: () {

                          controller.resendOtp();
                        // }
                      },
                      child: TextView(
                          text: keyResendCode,
                          textStyle: textStyleTitleSmall()!.copyWith(
                              color: AppColors.textGreyColorDark,
                              fontWeight: FontWeight.w600)))
                  .paddingOnly(right: margin_8),
              Visibility(
                visible: controller.isResendingOtp.value,
                child: Platform.isAndroid
                    ? SizedBox(
                        height: font_14,
                        width: font_14,
                        child: CircularProgressIndicator(
                          strokeWidth: height_1,
                          color: AppColors.appColor,
                        ),
                      )
                    : CupertinoActivityIndicator(
                        radius: height_6,
                      ),
              )
            ],
          );
  }

  Widget _yourOtpWidget() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color:
                greyColorLight.withOpacity(0.6),
            borderRadius: BorderRadius.circular(radius_3)),
        child: TextView(
          text: '${keyYourOtpIs.tr} 123456',
          textStyle: textStyleTitleSmall()!,
        ).paddingSymmetric(vertical: margin_5, horizontal: margin_8),
      ),
    );
  }
}
