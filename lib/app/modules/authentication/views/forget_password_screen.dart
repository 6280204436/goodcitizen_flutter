import 'package:good_citizen/app/core/utils/localizations/localization_controller.dart';
import 'package:good_citizen/app/modules/authentication/controllers/forget_password_controller.dart';
import 'package:good_citizen/app/modules/authentication/controllers/select_signup_controller.dart';
import 'package:good_citizen/app/modules/authentication/widgets/language_selection_widget.dart';

import '../../../common_data.dart';
import '../../../core/utils/email_formatter.dart';
import '../../../core/utils/show_bottom_sheet.dart';
import '../../../export.dart';
import '../controllers/login_controller.dart';

class ForgetPasswordScreen extends GetView<ForgetPasswordController> {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Get.height * 0.2,
                child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back_ios)
                        .marginSymmetric(horizontal: 20)),
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
                      text: "Forget Password",
                      maxLines: 1,
                      textStyle: textStyleDisplayMedium()!.copyWith(
                          color: Color.fromRGBO(221, 78, 75, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ).marginOnly(top: margin_35, left: margin_20),
                    // TextView(
                    //   text: "",
                    //   maxLines: 1,
                    //   textStyle: textStyleDisplayMedium()!.copyWith(color:Color.fromRGBO(221,78,75, 1),fontSize:14,fontWeight:FontWeight.w300 ),
                    // ).marginOnly(top:margin_4,left: margin_20),

                    _formWidget(),

                    Expanded(child: SizedBox()),

                    _buttonWidget().marginOnly(bottom: margin_20),
                    // Center(child: _richTextWidget()).marginOnly(bottom: 20)
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _formWidget() {
    return SingleChildScrollView(child: _fieldWidgets());
  }

  Widget _fieldWidgets() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          _emailField().paddingOnly(
              bottom: margin_22,
              left: margin_20,
              right: margin_20,
              top: margin_20),
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
      // onChanged: (value) {
      //   controller.emailString.value = value;
      // },
      inputFormatters: [EmailTextInputFormatter()],
      validator: (value) => EmailValidator.validateEmail(
          title: keyEmail.tr.toLowerCase(), value: value?.trim() ?? ""),
      inputType: TextInputType.emailAddress,
    );
  }

  Widget _buttonWidget() {
    return CustomMaterialButton(
      bgColor: Color.fromRGBO(221, 78, 75, 1),
      textColor: Colors.white,
      borderRadius: 30,
      onTap: () {
        controller.validate();
      },
      buttonText: keyNext.tr,
    ).marginSymmetric(horizontal: 20, vertical: 20);
  }
}
