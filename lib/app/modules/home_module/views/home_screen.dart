import 'package:avatar_glow/avatar_glow.dart';
import 'package:good_citizen/generated/assets.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:good_citizen/app/core/values/theme_controller.dart';
import 'package:good_citizen/app/core/widgets/boune_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/show_bottom_sheet.dart';
import '../../../core/widgets/network_image_widget.dart';
import '../../../export.dart';
import '../controllers/home_controller.dart';
import '../widgets/ride_request_widget.dart';

class HomeScreen extends GetView<HomeController> {
  // late HomeController controller;

  HomeScreen({super.key}) {
    // controller = Get.put(HomeController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
          // floatingActionButton:
          // _switchButton().paddingOnly(bottom: Get.height * 0.20),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          body: _bodyWidget(),
        )));
  }

  Widget _bodyWidget() {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: controller.userResponseModel.value?.data?.approval == "PENDING"
          ? Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: Get.height * 0.2,
                  ),
                  Icon(
                    Icons.pending_actions_outlined,
                    color: Color.fromRGBO(221, 78, 75, 1),
                    size: 100,
                  ),
                  TextView(
                    text: "Please wait for Approval",
                    textStyle: textStyleDisplayMedium()!.copyWith(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ).marginOnly(bottom: margin_5),
                  TextView(
                    text:
                        "Your details has Submitted and we will notify once its approved",
                    maxLines: 4,
                    textAlign: TextAlign.center,
                    textStyle: textStyleDisplayMedium()!.copyWith(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ).marginOnly(bottom: margin_5),
                  SizedBox(
                    height: Get.height * 0.3,
                  ),
                  _buttonWidget()
                ],
              ).marginSymmetric(horizontal: 40),
            )
          : controller.userResponseModel.value?.data?.approval == "REJECTED"
              ? Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: Get.height * 0.2,
                      ),
                      Icon(
                        Icons.pending_actions_outlined,
                        color: Color.fromRGBO(221, 78, 75, 1),
                        size: 100,
                      ),
                      TextView(
                        text: "Your account rejected",
                        textStyle: textStyleDisplayMedium()!.copyWith(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ).marginOnly(bottom: margin_5),
                      TextView(
                        text:
                            "Your profile has been rejected due to incomplete details",
                        maxLines: 4,
                        textAlign: TextAlign.center,
                        textStyle: textStyleDisplayMedium()!.copyWith(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ).marginOnly(bottom: margin_5),
                      SizedBox(
                        height: Get.height * 0.3,
                      ),
                      _buttonWidget()
                    ],
                  ).marginSymmetric(horizontal: 40),
                )
              : Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    _mapWidget(),
                    Obx(() => controller
                                .userResponseModel?.value?.data?.rideid !=
                            null
                        ? Container(
                            height: height_250,
                            width: Get.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      color: Color.fromRGBO(244, 67, 54, 1),
                                    ).marginOnly(right: margin_10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextView(
                                          text: "Current Location",
                                          textStyle: textStyleDisplayMedium()!
                                              .copyWith(
                                                  color: Color.fromRGBO(
                                                      90, 90, 90, 1),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                        ).marginOnly(bottom: margin_5),
                                        Container(
                                          width: Get.width * 0.6,
                                          child: TextView(
                                            text: controller
                                                    .startRideResponse
                                                    ?.value
                                                    ?.data
                                                    ?.pickupAddress ??
                                                "",
                                            textStyle: textStyleDisplayMedium()!
                                                .copyWith(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ).marginOnly(left: 20, right: 20, top: 20),
                                Row(
                                  children: [
                                    Container(
                                      width: 1,
                                      height: Get.height * 0.02,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color.fromRGBO(
                                                  8, 183, 131, 1),
                                              style: BorderStyle.solid)),
                                    ).marginOnly(left: 31),
                                    Container(
                                      child: TextView(
                                        text:
                                            "${controller.userResponseModel.value?.data?.distance?.toStringAsFixed(2)} Km",
                                        textStyle: textStyleDisplayMedium()!
                                            .copyWith(
                                                color: Color.fromRGBO(
                                                    90, 90, 90, 1),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                      ).marginOnly(left: margin_20),
                                    ).marginSymmetric(vertical: 5),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      color: Color.fromRGBO(8, 183, 131, 1),
                                    ).marginOnly(right: margin_10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextView(
                                          text: "Destination Location",
                                          textStyle: textStyleDisplayMedium()!
                                              .copyWith(
                                                  color: Color.fromRGBO(
                                                      90, 90, 90, 1),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                        ).marginOnly(bottom: margin_5),
                                        Container(
                                          width: Get.width * 0.6,
                                          child: TextView(
                                            text: controller
                                                    .startRideResponse
                                                    ?.value
                                                    ?.data
                                                    ?.dropAddress ??
                                                "",
                                            textStyle: textStyleDisplayMedium()!
                                                .copyWith(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ).marginOnly(left: 20, right: 20, bottom: 20),
                                CustomMaterialButton(
                                  bgColor: Color.fromRGBO(221, 78, 75, 1),
                                  textColor: Colors.white,
                                  borderRadius: 30,
                                  onTap: () {
                                    controller.validate(controller
                                        .userResponseModel
                                        ?.value
                                        ?.data
                                        ?.rideid);
                                  },
                                  buttonText: "End Ride",
                                ).marginOnly(bottom: 20, left: 60, right: 60)
                              ],
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              await Get.toNamed(AppRoutes.picupLocationScreen);

                              controller.loadProfile();
                            },
                            child: Container(
                              height: height_75,
                              width: Get.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20))),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 2)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextView(
                                      text: "Enter Your Location",
                                      textStyle: textStyleDisplayMedium()!
                                          .copyWith(
                                              color:
                                                  Colors.grey.withOpacity(0.6),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(221, 78, 75, 1),
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: Center(
                                        child: Icon(
                                          Icons.search_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ).marginSymmetric(horizontal: 10),
                              ).marginAll(20),
                            ),
                          ))
                  ],
                ),
    );
  }

  Widget _mapWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: Get.width,
          height: Get.height,
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Animarker(
                useRotation: true,
                shouldAnimateCamera: true,
                isActiveTrip:
                    controller.userResponseModel?.value?.data?.rideid != null,
                zoom: initialMapZoom,
                duration: const Duration(seconds: 10),
                curve: Curves.easeInOut,
                markers: controller.routeMarkers.values.toSet(),
                mapId: controller.completer.future
                    .then<int>((value) => value.mapId),
                child: GoogleMap(
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    polylines:
                        controller.userResponseModel?.value?.data?.rideid !=
                                null
                            ? Set<Polyline>.of(controller.routePolylines.values)
                            : {},
                    style: Get.find<ThemeController>().getMapTheme(),
                    onTap: controller.onMapTap,
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                      ),
                    },
                    myLocationButtonEnabled: false,
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: true,
                    initialCameraPosition: controller.initialCameraPosition,
                    onMapCreated: controller.onMapCreated),
              ),
              _profileLocationIcons().marginOnly(
                  bottom:
                      controller.userResponseModel?.value?.data?.rideid != null
                          ? margin_260
                          : margin_60),
              Obx(
                () => controller.userResponseModel.value?.data?.rideid != null
                    ? CustomMaterialButton(
                        bgColor: Color.fromRGBO(221, 78, 75, 1),
                        textColor: Colors.white,
                        borderRadius: 30,
                        onTap: () async {
                          final double destinationLat = controller
                                  .startRideResponse
                                  .value
                                  ?.data
                                  ?.dropLocation
                                  ?.latitude ??
                              0.0;
                          final double destinationLng = controller
                                  .startRideResponse
                                  .value
                                  ?.data
                                  ?.dropLocation
                                  ?.longitude ??
                              0.0;

                          final Uri uri = Uri.parse(
                              'google.navigation:q=$destinationLat,$destinationLng&mode=d');

                          try {
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              Get.snackbar('Error',
                                  'Google Maps is not installed on this device.');
                            }
                          } catch (e) {
                            Get.snackbar(
                                'Error', 'Failed to open Google Maps: $e');
                          }
                        },
                        buttonText: "Get Directions",
                      ).marginOnly(
                        bottom: 0, left: 60, right: 60, top: Get.height * 0.19)
                    : SizedBox(),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _profileLocationIcons() {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          SafeArea(
            child: Obx(
              () => Container(
                decoration: BoxDecoration(
                    // image:DecorationImage(image:AssetImage(imageBackgroundProfile,),fit: BoxFit.fill),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextView(
                      text:
                          "Welcome${controller.firstname.value.isNotEmpty ? ", " + '${controller.firstname.value[0].toUpperCase()}${controller.firstname.value.substring(1)}' : ""}",
                      maxLines: 1,
                      textStyle: textStyleDisplayMedium()!.copyWith(
                          color: Color.fromRGBO(221, 78, 75, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ).marginSymmetric(horizontal: 15),
                    GestureDetector(
                      onTap: () async {
                        await Get.toNamed(AppRoutes.profileRoute, arguments: {
                          "model": controller.userResponseModel.value
                        });
                        controller.loadProfile();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(221, 78, 75, 1),
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: TextView(
                            text:
                                "${controller.firstname.value.isNotEmpty ? controller.firstname.value[0].toUpperCase() : "${controller.email.isNotEmpty ? controller.email[0].toUpperCase() : ""}"}",
                            maxLines: 1,
                            textStyle: textStyleDisplayMedium()!.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ).marginAll(10),
                    )
                  ],
                ),
              ).marginSymmetric(vertical: 10),
            ),
          ),
          SizedBox(
            width: Get.width,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: controller.moveToCurrentLocation,
                    child: AssetSVGWidget(
                      icCurrentLocIcon,
                      imageWidth: height_38,
                      imageHeight: height_38,
                    ),
                  ),
                ),
                // _switchButton()
              ],
            ),
          )
        ])
        .paddingSymmetric(horizontal: margin_15)
        .paddingOnly(bottom: margin_40);
  }

  Widget _buttonWidget() {
    return CustomMaterialButton(
      bgColor: Color.fromRGBO(221, 78, 75, 1),
      textColor: Colors.white,
      borderRadius: 30,
      onTap: () {
        customLoader.show(Get.context);
        repository.getProfileApiCall().then((value) async {
          if (value != null) {
            controller.userResponseModel.value = value;
            customLoader.hide();
          }
        });
      },
      buttonText: "Check Status",
    ).marginSymmetric(horizontal: 20, vertical: 20);
  }
}
