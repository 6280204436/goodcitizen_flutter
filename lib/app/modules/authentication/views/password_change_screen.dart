import 'package:good_citizen/app/core/utils/localizations/localization_controller.dart';
import 'package:good_citizen/app/modules/authentication/controllers/forget_password_controller.dart';
import 'package:good_citizen/app/modules/authentication/controllers/password_change_controller.dart';
import 'package:good_citizen/app/modules/authentication/controllers/select_signup_controller.dart';
import 'package:good_citizen/app/modules/authentication/widgets/language_selection_widget.dart';

import '../../../common_data.dart';
import '../../../core/utils/email_formatter.dart';
import '../../../core/utils/show_bottom_sheet.dart';
import '../../../export.dart';
import '../controllers/login_controller.dart';

class PasswordChangeScreen extends GetView<PasswordChangeController> {
  const PasswordChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _appBarWidget(),
      body: _bodyWidget(),
    );
  }



  Widget _bodyWidget() {
    return _backGroundImage();
  }


  Widget _backGroundImage() => SingleChildScrollView(
    physics: ClampingScrollPhysics(),
    child: Container(width:Get.width,decoration: BoxDecoration(gradient: LinearGradient(  begin: Alignment.bottomLeft, // Start from top
      end: Alignment.topRight, colors:[Color.fromRGBO(200, 41,39,1),Color.fromRGBO(221,78,75,1)],)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height:Get.height*0.2,
            // child: TextView(
            //   text: "ForGEt".toUpperCase(),
            //   maxLines: 1,
            //   textStyle: textStyleDisplayMedium()!.copyWith(color:AppColors.whiteAppColor.withOpacity(0.1),fontSize:70,fontWeight:FontWeight.w600 ),
            // ).marginOnly(top:Get.height*0.12 ),
          ),
          Container(width:Get.width,height:Get.height*0.8,decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight:Radius.circular(20))),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextView(
                  text: "Set New Password",
                  maxLines: 1,
                  textStyle: textStyleDisplayMedium()!.copyWith(color:Color.fromRGBO(221,78,75, 1),fontSize:18,fontWeight:FontWeight.w600 ),
                ).marginOnly(top:margin_35,left: margin_20),
                // TextView(
                //   text: "",
                //   maxLines: 1,
                //   textStyle: textStyleDisplayMedium()!.copyWith(color:Color.fromRGBO(221,78,75, 1),fontSize:14,fontWeight:FontWeight.w300 ),
                // ).marginOnly(top:margin_4,left: margin_20),

                _formWidget(),


                Expanded(child: SizedBox()),

                _buttonWidget().marginOnly(bottom:margin_20),
                // Center(child: _richTextWidget()).marginOnly(bottom: 20)
              ],),
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

          _passwordTextField().paddingOnly(bottom: margin_22,left: margin_20,right: margin_20,top: margin_20),

          _confirmPasswordTextField().paddingOnly(bottom: margin_22,left: margin_20,right: margin_20),


        ],
      ),
    );
  }


  Widget _passwordTextField() => Obx(
        () => TextFieldWidget(
      controller: controller.passwordController,
      textInputAction: TextInputAction.done,
      focusNode: controller.passwordFocusNode,
      obscureText: controller.isShow.value,
      suffixIcon:IconButton(onPressed: (){
        controller.isShow.value=!controller.isShow.value;
      }, icon: Icon( controller.isShow.value? Icons.visibility
          : Icons.visibility_off,),
      ),


      hintText: "Enter your password",
      labelTextStyle: textStyleTitleSmall()!.copyWith(
          fontWeight: FontWeight.w400, color: Colors.black),
      labelText: "Password",
      // onChanged: (value) {
      //   controller.emailString.value = value;
      // },

      validator: (value) => PasswordFormValidator.validatePassword(
          title: keyPassword.tr.toLowerCase(), value: value?.trim() ?? ""),
      inputType: TextInputType.emailAddress,
    ).paddingOnly(bottom: margin_12),
  );

  Widget _confirmPasswordTextField() => Obx(
        () => TextFieldWidget(
      controller: controller.confirmPasswordController,
      textInputAction: TextInputAction.done,
      focusNode: controller.confirmPasswordFocusNode,
      obscureText: controller.ispassShow.value,
      suffixIcon:IconButton(onPressed: (){
        controller.ispassShow.value=!controller.ispassShow.value;
      }, icon: Icon( controller.ispassShow.value? Icons.visibility
          : Icons.visibility_off,),
      ),


      hintText: "Enter your confirmed password",
      labelTextStyle: textStyleTitleSmall()!.copyWith(
          fontWeight: FontWeight.w400, color: Colors.black),
      labelText: "Confirm Password",
      // onChanged: (value) {
      //   controller.emailString.value = value;
      // },

      validator: (value) => PasswordFormValidator.validateConfirmPasswordMatch(
          title: keyPassword.tr.toLowerCase(), value: value?.trim() ?? "",password: controller.passwordController.text),
      inputType: TextInputType.emailAddress,
    ).paddingOnly(bottom: margin_12),
  );

  Widget _buttonWidget() {
    return CustomMaterialButton(
      bgColor: Color.fromRGBO(221,78,75,1),
      textColor: Colors.white,
      borderRadius: 30,
      onTap: (){
        controller.validate();

      },
      buttonText: keyNext.tr,
    ).marginSymmetric(horizontal: 20,vertical: 20);
  }



}
