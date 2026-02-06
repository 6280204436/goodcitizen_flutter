import 'package:dotted_border/dotted_border.dart';
import 'package:good_citizen/app/core/utils/localizations/localization_controller.dart';
import 'package:good_citizen/app/modules/authentication/controllers/select_signup_controller.dart';
import 'package:good_citizen/app/modules/authentication/controllers/sign_up_controller.dart';
import 'package:good_citizen/app/modules/profile/controllers/update_document_controller.dart';
import 'package:intl/intl.dart';


import '../../../core/widgets/network_image_widget.dart' show FileSizeEnum, NetworkImageWidget;
import '../../../core/widgets/show_dialog.dart';
import '../../../export.dart';


class UpdateDocumentView extends GetView<UpdateDocumentController> {
  const UpdateDocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: _appBarWidget(),
      body: _bodyWidget(),
    );
  }

  AppBar _appBarWidget() {
    return customAppBar(
      bgColor: Color.fromRGBO(221, 78, 75, 1),
      titleText: keyProfile.tr,
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
            height:Get.height*0.03,
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

                  _formWidget(),
                  _buttonWidget(),

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



  Widget imageWidget() {
    return GestureDetector(
      // onTap: (){
      //   print(">>>>>>>${controller.userResponseModel?.value?.data?.aadharFront}");
      // },
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
              :controller.userResponseModel?.value?.data?.aadharFront!=null?
          NetworkImageWidget(
                              imageUrl:
                                  controller.userResponseModel?.value?.data?.profile_pic ??
                                      "",
                              imageHeight: height_120,
                              imageWidth: height_120,
                              includeBaseUrl: true,
                              placeHolder: userPlaceholder,
                              imageFitType: BoxFit.contain,
                              radiusAll: radius_8,
                            )
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
              :controller.userResponseModel?.value?.data?.aadharBack!=null?
          NetworkImageWidget(
            imageUrl:
            controller.userResponseModel?.value?.data?.aadharBack ??
                "",
            imageHeight: height_120,
            imageWidth: height_120,
            includeBaseUrl: true,
            placeHolder: userPlaceholder,
            imageFitType: BoxFit.contain,
            radiusAll: radius_8,
          )
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
      suffixIcon: IconButton(onPressed: ()async{
      await  controller.goToWebPage("https://goodcitizen.s3.ap-south-1.amazonaws.com/documents/${controller.userResponseModel.value?.data?.hospitalDoc}");

      }, icon:Icon(Icons.cloud_download_outlined)),
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
              :controller.userResponseModel?.value?.data?.dlFront!=null?
          NetworkImageWidget(
            imageUrl:
            controller.userResponseModel?.value?.data?.dlFront ??
                "",
            imageHeight: Get.height*0.2,
            imageWidth: Get.width,
            includeBaseUrl: true,
            placeHolder: userPlaceholder,
            radiusAll: radius_8,
            imageFitType: BoxFit.contain,
          )
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
              :controller.userResponseModel?.value?.data?.dlBack!=null?
          NetworkImageWidget(
            imageUrl:
            controller.userResponseModel?.value?.data?.aadharBack ??
                "",
            imageHeight: Get.height*0.2,
            imageWidth: Get.width,
            includeBaseUrl: true,
            placeHolder: userPlaceholder,
            radiusAll: radius_8,
            imageFitType: BoxFit.contain,
          )
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
      buttonText: "Submit",
    ).marginSymmetric(horizontal: 20,vertical: 20);
  }




}
