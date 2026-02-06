import 'package:good_citizen/app/core/widgets/network_image_widget.dart';
import 'package:good_citizen/app/core/widgets/show_dialog.dart';
import 'package:good_citizen/app/modules/home_module/controllers/Picup_Controller.dart';
import '../../../export.dart';
import '../../../location_picker_field.dart';

class PicupDestinationScreen extends GetView<PicupController> {
  const PicupDestinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(221, 78, 75, 1),
        extendBody: false,
        body: _bodyWidget().paddingOnly(bottom: margin_0));
  }

  Widget _bodyWidget() {
    return _bodyList().paddingOnly(bottom: margin_0);
  }

  SingleChildScrollView _bodyList() {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
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
                  child: Icon(Icons.arrow_back, color: Colors.white)
                      .marginSymmetric(horizontal: 20))),
          Container(
              height: Get.height * 0.8,
              width: Get.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextView(
                    text: "Select Address",
                    maxLines: 1,
                    textStyle: textStyleDisplayMedium()!.copyWith(
                        color: Color.fromRGBO(90, 90, 90, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ).marginOnly(
                      top: margin_35, left: margin_20, right: margin_20),
                  TextView(
                    text:
                        "Enter your current location and destination address to see route",
                    maxLines: 2,
                    textStyle: textStyleDisplayMedium()!.copyWith(
                        color: Color.fromRGBO(90, 90, 90, 1),
                        fontSize: 12,
                        fontWeight: FontWeight.w300),
                  ).marginOnly(
                      top: margin_10,
                      left: margin_20,
                      right: margin_20,
                      bottom: 10),
                  Container(
                          height: 1,
                          width: Get.width,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromRGBO(221, 221, 221, 1),
                                  width: 1)))
                      .marginSymmetric(
                          horizontal: margin_20, vertical: margin_10),
                  _streetField(),
                  const Spacer(),
                  _buttonWidget().marginOnly(bottom: margin_25)
                ],
              )),
        ],
      ),
    );
  }

  Widget _streetField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // GestureDetector(
            //   onTap: () {
            //     controller.fetchCurrentLocation();
            //   },
            Icon(Icons.my_location, color: Colors.black)
                .marginOnly(right: margin_10),
            // ),
            TextView(
              text: "Driving From ",
              maxLines: 1,
              textStyle: textStyleDisplayMedium()!.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ).marginOnly(top: 10),
        GoogleLocationPickerTextField(
          focusNode: controller.streetFocusNode,
          controller: controller.streetController,
          showBorder: true,
          hintText: keyStreet,
          suffixIcon: GestureDetector(
            onTap: () {
              controller.fetchCurrentLocation();
            },
            child: Icon(Icons.add_location, color: Colors.black)
                .marginOnly(right: margin_10),
          ),
          onPlaceTap: controller.onPlaceTap,
        ),
        SizedBox(height: height_20),
        Row(
          children: [
            Icon(Icons.location_on_rounded, color: Colors.black)
                .marginOnly(right: margin_10),
            TextView(
              text: "Driving To",
              maxLines: 1,
              textStyle: textStyleDisplayMedium()!.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        GoogleLocationPickerTextField(
          focusNode: controller.streetDropFocusNode,
          controller: controller.streetDropController,
          showBorder: true,
          hintText: keyStreet,
          onPlaceTap: controller.onPlaceTap,
        ),
      ],
    ).marginSymmetric(horizontal: 20);
  }

  Widget _buttonWidget() {
    return CustomMaterialButton(
      bgColor: Color.fromRGBO(221, 78, 75, 1),
      textColor: Colors.white,
      borderRadius: 30,
      onTap: () {
        controller.validate();
      },
      buttonText: "Start Ride",
    ).marginSymmetric(horizontal: 60, vertical: 20);
  }

  Widget _dividerWidget() {
    return Divider(
        height: margin_25,
        color: isDarkMode.value
            ? AppColors.whiteLight
            : AppColors.appGreyColorDark);
  }
}

class Ride {
  final int id;
  final String name;

  Ride({required this.id, required this.name});
}
