
import '../../../export.dart';
import '../../authentication/models/auth_request_model.dart';
import '../controllers/change_password_controller.dart';


class ChangepasswordScreen extends GetView<ChangePasswordController> {
  const ChangepasswordScreen({super.key});

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
      titleText: "Update Password",
    );
  }

  Widget _bodyWidget() {
    return _bodyList().paddingOnly(bottom: margin_0);
  }

  Widget _bodyList() {
    return Container(
        width: Get.width,
        height: Get.height*0.9,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              _formWidget(),
             SizedBox(height: Get.height*0.2,),
              _buttonWidget()
            ],
          ),
        )).marginOnly(
      top: margin_20,
    );
  }
  Widget _formWidget() {
    return SingleChildScrollView(child: _fieldWidgets());
  }


  Widget _fieldWidgets() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          _oldpasswordTextField().marginOnly(top: 20,left: 20,right: 20),
          _passwordTextField().paddingOnly(bottom: margin_22,left: margin_20,right: margin_20,top: margin_20),

          _confirmPasswordTextField().paddingOnly(bottom: margin_20,left: margin_20,right: margin_20),


        ],
      ),
    );
  }

  Widget _oldpasswordTextField() =>  TextFieldWidget(
    controller: controller.stateController,
    textInputAction: TextInputAction.done,
    focusNode: controller.stateFocusNode,
  validator: (value) => NameValidator.validateName(
  title: "Old Password".toLowerCase(),
  value: value?.trim() ?? '',
  ),



    hintText: "Enter your Old password",
    labelTextStyle: textStyleTitleSmall()!.copyWith(
        fontWeight: FontWeight.w400, color: Colors.black),
    labelText: "Old Password",
    // onChanged: (value) {
    //   controller.emailString.value = value;
    // },


    inputType: TextInputType.emailAddress,
  ).paddingOnly(bottom: margin_12,
  );


  Widget _passwordTextField() =>  TextFieldWidget(
      controller: controller.cityController,
      textInputAction: TextInputAction.done,
      focusNode: controller.cityNode,



      hintText: "Enter your password",
      labelTextStyle: textStyleTitleSmall()!.copyWith(
          fontWeight: FontWeight.w400, color: Colors.black),
      labelText: "New Password",
      // onChanged: (value) {
      //   controller.emailString.value = value;
      // },

      validator: (value) => PasswordFormValidator.validatePassword(
          title: keyPassword.tr.toLowerCase(), value: value?.trim() ?? ""),
      inputType: TextInputType.emailAddress,
    ).paddingOnly(bottom: margin_12,
  );

  Widget _confirmPasswordTextField() =>TextFieldWidget(
      controller: controller.emailController,
      textInputAction: TextInputAction.done,
      focusNode: controller.emailFocusNode,

      hintText: "Enter your confirmed password",
      labelTextStyle: textStyleTitleSmall()!.copyWith(
          fontWeight: FontWeight.w400, color: Colors.black),
      labelText: "Confirm Password",
      // onChanged: (value) {
      //   controller.emailString.value = value;
      // },

      validator: (value) => PasswordFormValidator.validateConfirmPasswordMatch(
          title: keyPassword.tr.toLowerCase(), value: value?.trim() ?? "",password: controller.emailController.text),
      inputType: TextInputType.emailAddress,
    ).paddingOnly(bottom: margin_12
  );








  Widget _buttonWidget() {
    return CustomMaterialButton(
      bgColor: Color.fromRGBO(221, 78, 75, 1),
      textColor: Colors.white,
      borderRadius: 30,
      onTap: () {
    if (controller.formKey.currentState!.validate()) {
        Map<String, dynamic> requestModel = AuthRequestModel.editProfile(
          oldPassword: controller.stateController.text,
          newPassword: controller.emailController.text,

        );
        controller.handleSubmit(requestModel);
        }
      },
      buttonText: "Update",
    ).marginSymmetric(horizontal: 20, vertical: 40);
  }



}
