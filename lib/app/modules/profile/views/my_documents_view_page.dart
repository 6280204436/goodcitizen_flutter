import 'package:good_citizen/app/core/widgets/network_image_widget.dart';

import '../../../export.dart';
import '../controllers/my_document_view_controller.dart';


class MyDocumentsViewPage extends GetView<MyDocumentViewController> {
  const MyDocumentsViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(221, 78, 75, 1),
        extendBody: false,
        appBar: _appBarWidget(),
        body: Obx(() => _bodyWidget().paddingOnly(bottom: margin_0)));
  }

  AppBar _appBarWidget() {
    return customAppBar(
      bgColor: Color.fromRGBO(221, 78, 75, 1),
      titleText: "My Documents",
    );
  }

  Widget _bodyWidget() {
    return _bodyList().paddingOnly(bottom: margin_0);
  }

  Widget _bodyList() {
    return Container(
        height: Get.height * 0.865,
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [


                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  TextView(
                    text:
                    "Aadhaar Front",
                    maxLines: 1,
                    textStyle: textStyleTitleLarge()!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 14),
                    textAlign: TextAlign.start,
                  ).marginSymmetric(horizontal: 20,vertical: 20),
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.black.withOpacity(0.3)),borderRadius: BorderRadius.circular(20)),
                    child: NetworkImageWidget(
                      imageUrl:
                      controller.userResponseModel?.value?.data?.aadharFront ??
                          "",
                      imageHeight: height_175,
                      imageWidth: Get.width,
                      includeBaseUrl: true,
                      placeHolder: userPlaceholder,
                      imageFitType: BoxFit.contain,
                      radiusAll: radius_8,
                    ),
                  ).marginSymmetric(horizontal: 20),
                    TextView(
                      text:
                      "Aadhaar Back",
                      maxLines: 1,
                      textStyle: textStyleTitleLarge()!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 14),
                      textAlign: TextAlign.start,
                    ).marginSymmetric(horizontal: 20,vertical: 20),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black.withOpacity(0.3)),borderRadius: BorderRadius.circular(20)),
                      child: NetworkImageWidget(
                        imageUrl:
                        controller.userResponseModel?.value?.data?.aadharBack ??
                            "",
                        imageHeight: height_175,
                        imageWidth: Get.width,
                        includeBaseUrl: true,
                        placeHolder: userPlaceholder,
                        imageFitType: BoxFit.contain,
                        radiusAll: radius_8,
                      ),
                    ).marginSymmetric(horizontal: 20),
                    TextView(
                      text:
                      "Driving Licence Front",
                      maxLines: 1,
                      textStyle: textStyleTitleLarge()!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 14),
                      textAlign: TextAlign.start,
                    ).marginSymmetric(horizontal: 20,vertical: 20),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black.withOpacity(0.3)),borderRadius: BorderRadius.circular(20)),
                      child: NetworkImageWidget(
                        imageUrl:
                        controller.userResponseModel?.value?.data?.dlFront ??
                            "",
                        imageHeight: height_175,
                        imageWidth: Get.width,
                        includeBaseUrl: true,
                        placeHolder: userPlaceholder,
                        imageFitType: BoxFit.contain,
                        radiusAll: radius_8,
                      ),
                    ).marginSymmetric(horizontal: 20),
                    TextView(
                      text:
                      "Driving Licence Back",
                      maxLines: 1,
                      textStyle: textStyleTitleLarge()!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 14),
                      textAlign: TextAlign.start,
                    ).marginSymmetric(horizontal: 20,vertical: 20),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black.withOpacity(0.3)),borderRadius: BorderRadius.circular(20)),
                      child: NetworkImageWidget(
                        imageUrl:
                        controller.userResponseModel?.value?.data?.dlBack ??
                            "",
                        imageHeight: height_175,
                        imageWidth: Get.width,
                        includeBaseUrl: true,
                        placeHolder: userPlaceholder,
                        imageFitType: BoxFit.contain,
                        radiusAll: radius_8,
                      ),
                    ).marginSymmetric(horizontal: 20),

                    TextFieldWidget(
                      controller: controller.confimPasswordController,
                      readOnly: true, // Prevents manual editing
                      // onTap: () async {
                      //
                      //   await controller.pickPdfFile(); // Open PDF file picker
                      //
                      // },
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
                    ).marginSymmetric(horizontal: 20,vertical: 20)
                  ],).marginOnly(bottom: 40),


            ],
          ),
        )).marginOnly(top: margin_20);
  }




}
