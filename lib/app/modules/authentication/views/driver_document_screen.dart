import 'package:dotted_border/dotted_border.dart';
import 'package:good_citizen/app/core/utils/localizations/localization_controller.dart';
import 'package:good_citizen/app/modules/authentication/controllers/select_signup_controller.dart';
import 'package:good_citizen/app/modules/authentication/controllers/sign_up_controller.dart';
import 'package:intl/intl.dart';


import '../../../core/widgets/network_image_widget.dart' show FileSizeEnum, NetworkImageWidget;
import '../../../core/widgets/show_dialog.dart';
import '../../../export.dart';
import '../controllers/driver_document_controller.dart';
import '../controllers/login_controller.dart';

class DriverDocumentScreen extends GetView<DriverDocumentController> {
  const DriverDocumentScreen({super.key});

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
    child: Container(width:Get.width,decoration: BoxDecoration(gradient: LinearGradient(  begin: Alignment.bottomLeft, // Start from top
      end: Alignment.topRight, colors:[Color.fromRGBO(200, 41,39,1),Color.fromRGBO(221,78,75,1)],)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height:Get.height*0.2,
            // child: TextView(
            //   text: "Signup".toUpperCase(),
            //   maxLines: 1,
            //   textStyle: textStyleDisplayMedium()!.copyWith(color:AppColors.whiteAppColor.withOpacity(0.1),fontSize:70,fontWeight:FontWeight.w600 ),
            // ).marginOnly(top:Get.height*0.12 ),
          ),
          Container(width:Get.width,height:Get.height*0.8,decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight:Radius.circular(20))),

            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextView(
                    text: "We need to verify you",
                    maxLines: 2,
                    textStyle: textStyleDisplayMedium()!.copyWith(color:Color.fromRGBO(221,78,75, 1),fontSize:18,fontWeight:FontWeight.w600 ),
                  ).marginOnly(top:margin_35,left: margin_20,right:margin_20),
                  TextView(
                    text: "To verify your account on the platform we need to verify your identity",
                    maxLines: 2,
                    textStyle: textStyleDisplayMedium()!.copyWith(color:Color.fromRGBO(221,78,75, 1),fontSize:12,fontWeight:FontWeight.w300 ),
                  ).marginOnly(top:margin_4,left: margin_20,right:margin_20),

                  _formWidget(),


                  _buttonWidget(),
                  // Center(child: _richTextWidget()).marginOnly(bottom: 10),
                  Center(child: _termsRichtext()).marginOnly(bottom: 30)
                ],),
            ),
          ),

        ],
      ),
    ),
  );


  Widget _formWidget() {
    return _fieldWidgets();
  }

  Widget _fieldWidgets() {
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          TextView(
            text: "Please upload front or back of your government issued aadhar card ",
            maxLines: 2,
            textStyle: textStyleDisplayMedium()!.copyWith(color:Colors.black,fontSize:12,fontWeight:FontWeight.w400 ),
          ).marginOnly(top:margin_20,left: margin_20,right:margin_20),

          Obx(()=>imageWidget()).marginSymmetric(vertical: 10),
          Obx(()=>imageback()).marginSymmetric(vertical: 10),

          _licencenumber().marginSymmetric(horizontal: 20,vertical: 10),
          _licenceExpiry().marginSymmetric(horizontal: 20),
          TextView(
            text: "Please upload front or back of your government issued driving licence ",
            maxLines: 2,
            textStyle: textStyleDisplayMedium()!.copyWith(color:Colors.black,fontSize:12,fontWeight:FontWeight.w400 ),
          ).marginOnly(top:margin_20,left: margin_20,right:margin_20),
          Obx(()=>_licenceFrontWidget()).marginSymmetric(vertical: 10),
          Obx(()=>_licenceBackWidget()).marginSymmetric(vertical: 10),
          _numberplate().marginSymmetric(horizontal: 20,vertical: 10),
          _HospitalDocument().marginSymmetric(horizontal: 20,vertical: 10),


        ],
      ),
    );
  }



  Widget imageWidget() {
    return GestureDetector(
      onTap: controller.pickfrontAdhar,
      child:  DottedBorder(
        options: RoundedRectDottedBorderOptions(
          radius: Radius.circular(16),
          color: Colors.grey
        ),
        child: Container(
          height: Get.height*0.2,
          width: Get.width,
          decoration:  BoxDecoration(
              shape: BoxShape.rectangle, color: AppColors.whiteAppColor,borderRadius:BorderRadius.circular(10) ),
          child: controller.imageFile.value.localPath != null
              ? Image.file(
                File(controller.imageFile.value.localPath!),
                height:Get.height*0.2,
                width: Get.width,
                fit: BoxFit.contain,
              ).paddingAll(margin_4)
              :Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Icon(Icons.cloud_upload_outlined,color: Colors.grey),
            TextView(
              text: "upload front",
              maxLines: 2,
              textStyle: textStyleDisplayMedium()!.copyWith(color:Colors.black,fontSize:12,fontWeight:FontWeight.w400 ),
            ).marginOnly(top:margin_5),


          ],),
        ),
      ).marginSymmetric(horizontal: 20),
    );
  }

  Widget imageback() {
    return GestureDetector(
      onTap: controller.pickbackAdhar,
      child:  DottedBorder(
        options: RoundedRectDottedBorderOptions(
            radius: Radius.circular(16),
            color: Colors.grey
        ),
        child: Container(
          height: Get.height*0.2,
          width: Get.width,
          decoration:  BoxDecoration(
              shape: BoxShape.rectangle, color: AppColors.whiteAppColor,borderRadius:BorderRadius.circular(10) ),
          child: controller.imageBackAdhar.value.localPath != null
              ? Image.file(
            File(controller.imageBackAdhar .value.localPath!),
            height:Get.height*0.2,
            width: Get.width,
            fit: BoxFit.contain,
          ).paddingAll(margin_4)
              :Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload_outlined,color: Colors.grey),
              TextView(
                text: "upload back",
                maxLines: 2,
                textStyle: textStyleDisplayMedium()!.copyWith(color:Colors.black,fontSize:12,fontWeight:FontWeight.w400 ),
              ).marginOnly(top:margin_5),


            ],),
        ),
      ).marginSymmetric(horizontal: 20),
    );
  }

  TextFieldWidget _licencenumber() {
    return TextFieldWidget(
      controller: controller.lastnameController,
      textInputAction: TextInputAction.done,
      focusNode: controller.lastnameNode,
      hintText: "Enter your driving Licence number",
      labelTextStyle: textStyleTitleSmall()!.copyWith(
          fontWeight: FontWeight.w400, color: Colors.black),
      labelText: "Driving Licence Number",
      // onChanged: (value) {
      //   controller.emailString.value = value;
      // },

      validator: (value) => FieldChecker.fieldChecker(value: value,completeMessage: "Please enter Driving Licence Number"),
      inputType: TextInputType.text,
    );
  }

  TextFieldWidget _numberplate() {
    return TextFieldWidget(
      controller: controller.numberController,
      textInputAction: TextInputAction.done,
      focusNode: controller.phoneNode,
      hintText: "Enter ambulance plate number",
      labelTextStyle: textStyleTitleSmall()!.copyWith(
          fontWeight: FontWeight.w400, color: Colors.black),
      labelText: "Ambulance Plate Number",
      // onChanged: (value) {
      //   controller.emailString.value = value;
      // },

      validator: (value) => FieldChecker.fieldChecker(value: value,completeMessage: "Please enter Ambulance Plate Number "),
      inputType: TextInputType.text,
    );
  }

  TextFieldWidget _licenceExpiry() {
    return TextFieldWidget(
      controller: controller.firstnameController,
      readOnly: true, // Prevents manual editing
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context:Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          controller.firstnameController.text = formattedDate;
        }
      },
      focusNode: controller.firstnameNode,
      hintText: "Select Licence Expiry Date",
      labelText: "Licence Expiry Date",
      labelTextStyle: textStyleTitleSmall()!.copyWith(
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      validator: (value) => FieldChecker.fieldChecker(
        value: value,
        completeMessage: "Please select Licence Expiry Date",
      ),
      inputType: TextInputType.none, // Prevents keyboard from showing
      textInputAction: TextInputAction.none,
    );
  }

  TextFieldWidget _HospitalDocument() {
    return TextFieldWidget(
      controller: controller.confimPasswordController,
      readOnly: true, // Prevents manual editing
      onTap: () async {

          await controller.pickPdfFile(); // Open PDF file picker

      },
      focusNode: controller.confirmFocusNode,
      hintText: "Select HospitalDocument",
      labelText: "Hospital Document",
      labelTextStyle: textStyleTitleSmall()!.copyWith(
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      validator: (value) => FieldChecker.fieldChecker(
        value: value,
        completeMessage: "Please select Your Hospital Document",
      ),
      inputType: TextInputType.none, // Prevents keyboard from showing
      textInputAction: TextInputAction.none,
    );
  }

  Widget _licenceFrontWidget() {
    return GestureDetector(
      onTap: controller.pickfrontlicence,
      child:  DottedBorder(
        options: RoundedRectDottedBorderOptions(
            radius: Radius.circular(16),
            color: Colors.grey
        ),
        child: Container(
          height: Get.height*0.2,
          width: Get.width,
          decoration:  BoxDecoration(
              shape: BoxShape.rectangle, color: AppColors.whiteAppColor,borderRadius:BorderRadius.circular(10) ),
          child: controller.imageLicenceFont.value.localPath != null
              ? Image.file(
            File(controller.imageLicenceFont.value.localPath!),
            height:Get.height*0.2,
            width: Get.width,
            fit: BoxFit.contain,
          ).paddingAll(margin_4)
              :Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload_outlined,color: Colors.grey),
              TextView(
                text: "upload front",
                maxLines: 2,
                textStyle: textStyleDisplayMedium()!.copyWith(color:Colors.black,fontSize:12,fontWeight:FontWeight.w400 ),
              ).marginOnly(top:margin_5),


            ],),
        ),
      ).marginSymmetric(horizontal: 20),
    );
  }

  Widget _licenceBackWidget() {
    return GestureDetector(
      onTap: controller.pickbacklicence,
      child:  DottedBorder(
        options: RoundedRectDottedBorderOptions(
            radius: Radius.circular(16),
            color: Colors.grey
        ),
        child: Container(
          height: Get.height*0.2,
          width: Get.width,
          decoration:  BoxDecoration(
              shape: BoxShape.rectangle, color: AppColors.whiteAppColor,borderRadius:BorderRadius.circular(10) ),
          child: controller.imageLicenceBack.value.localPath != null
              ? Image.file(
            File(controller.imageLicenceBack.value.localPath!),
            height:Get.height*0.2,
            width: Get.width,
            fit: BoxFit.contain,
          ).paddingAll(margin_4)
              :Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload_outlined,color: Colors.grey),
              TextView(
                text: "upload back",
                maxLines: 2,
                textStyle: textStyleDisplayMedium()!.copyWith(color:Colors.black,fontSize:12,fontWeight:FontWeight.w400 ),
              ).marginOnly(top:margin_5),


            ],),
        ),
      ).marginSymmetric(horizontal: 20),
    );
  }


  Widget _buttonWidget() {
    return CustomMaterialButton(
      bgColor: Color.fromRGBO(221,78,75,1),
      textColor: Colors.white,
      borderRadius: 30,
      onTap: (){
        controller.validate();
      },
      buttonText: keySignUp.tr,
    ).marginSymmetric(horizontal: 20,vertical: 20);
  }



  RichText _termsRichtext() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'By using this app you are agreeing to our ',
          style: textStyleBodyMedium()!.copyWith(
              fontWeight: FontWeight.w400, color: AppColors.blackColor),
          children: [
            TextSpan(
                text: 'Terms & Condition',
                style: textStyleBodyMedium()!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(221, 78, 75, 1),
                    decoration: TextDecoration.underline,
                    decorationColor:Color.fromRGBO(221, 78, 75, 1),
                    decorationThickness: 2.0), // Thicker underline
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.toNamed(AppRoutes.staticPageRoute,arguments: {"from":"Terms"});
                  }),
            TextSpan(
                text: ' and ',
                style: textStyleBodyMedium()!.copyWith(
                    fontWeight: FontWeight.w400, color: AppColors.blackColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    if (Get.isRegistered<LoginController>()) {
                      Get.back();
                    } else {
                      Get.toNamed(AppRoutes.loginRoute);
                    }
                  }),
            TextSpan(
                text: 'Privacy Policy',
                style: textStyleBodyMedium()!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(221, 78, 75, 1),
                    decoration: TextDecoration.underline,
                    decorationColor:Color.fromRGBO(221, 78, 75, 1),
                    decorationThickness: 2.0), // Thicker underline
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.toNamed(AppRoutes.staticPageRoute,arguments: {"from":"Privacy"});

                  }),
          ]),
      maxLines: 3,
    );
  }
}
