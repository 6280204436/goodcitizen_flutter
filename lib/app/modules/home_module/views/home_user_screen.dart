import 'package:timeago/timeago.dart' as timeago;

import '../../../export.dart';

import '../controllers/home_user_controller.dart';

class HomeScreenUser extends StatelessWidget {
  HomeScreenUser({super.key});
  String formatTimeAgo(DateTime dateTime) {
    return timeago.format(dateTime);
  }

  final List<Color> avatarColors = [
    Colors.greenAccent.withOpacity(0.3),
    Colors.blueAccent.withOpacity(0.3),
    Colors.purpleAccent.withOpacity(0.3),
  ];
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: GetBuilder<HomeUserController>(
          init: HomeUserController(), // Make sure to initialize the controller
          builder: (controller) {
            return Obx(() => Container(
                color: controller.islist.value == "true"
                    ? Color.fromRGBO(221, 78, 75, 1)
                    : Colors.white,
                child: _bodyWidget(controller)));
          },
        ),
      ),
    );
  }

  _bodyList(controller) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              // image:DecorationImage(image:AssetImage(imageBackgroundProfile,),fit: BoxFit.fill),

              borderRadius: BorderRadius.circular(18)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: Get.width * 0.7,
                child: Obx(() => controller.firstname.value == ""
                    ? TextView(
                        text: "Welcome",
                        maxLines: 1,
                        textStyle: textStyleDisplayMedium()!.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      )
                    : TextView(
                        text:
                            "Welcome${controller.firstname.value != null ? ", " + '${controller.firstname.value[0].toUpperCase()}${controller.firstname.value.substring(1)}' : ""}",
                        maxLines: 1,
                        textStyle: textStyleDisplayMedium()!.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ).marginSymmetric(horizontal: 15)),
              ),
              GestureDetector(
                onTap: () async {
                  await Get.toNamed(AppRoutes.profileRoute,
                      arguments: {"model": controller.userResponseModel});
                  controller.loadProfile();
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: TextView(
                      text:
                          "${"${controller.email.isNotEmpty ? controller.email[0].toUpperCase() : ""}"}",
                      maxLines: 1,
                      textStyle: textStyleDisplayMedium()!.copyWith(
                          color: Color.fromRGBO(221, 78, 75, 1),
                          fontSize: 10,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ).marginAll(10),
              )
            ],
          ).paddingSymmetric(horizontal: margin_20),
        ).marginOnly(top: 41),
        Container(
            height: height_600,
            width: Get.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => {
                          controller.isselected.value = "true",
                          controller?.getNotification()
                        },
                        child: Container(
                          height: 50,
                          width: Get.width / 2.2,
                          decoration: BoxDecoration(
                              color: controller.isselected.value == "true"
                                  ? Color.fromRGBO(221, 78, 75, 1)
                                  : Colors.white,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1,
                                      color:
                                          controller.isselected.value == "true"
                                              ? Color.fromRGBO(221, 78, 75, 1)
                                              : Colors.black.withOpacity(0.2)),
                                  left: BorderSide(
                                      width: 1,
                                      color:
                                          controller.isselected.value == "true"
                                              ? Color.fromRGBO(221, 78, 75, 1)
                                              : Colors.black.withOpacity(0.2)),
                                  top: BorderSide(
                                      width: 1,
                                      color:
                                          controller.isselected.value == "true"
                                              ? Color.fromRGBO(221, 78, 75, 1)
                                              : Colors.black.withOpacity(0.2))),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20))),
                          child: Center(
                            child: TextView(
                              text: "Active".toUpperCase(),
                              maxLines: 1,
                              textStyle: textStyleDisplayMedium()!.copyWith(
                                color: controller.isselected.value == "true"
                                    ? Colors.white
                                    : Colors.black.withOpacity(0.3),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ).marginOnly(top: 20),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.isselected.value = "false";
                          controller?.getNotification();
                        },
                        child: Container(
                          height: 50,
                          width: Get.width / 2.2,
                          decoration: BoxDecoration(
                              color: controller.isselected.value != "true"
                                  ? Color.fromRGBO(221, 78, 75, 1)
                                  : Colors.white,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1,
                                      color:
                                          controller.isselected.value != "true"
                                              ? Color.fromRGBO(221, 78, 75, 1)
                                              : Colors.black.withOpacity(0.2)),
                                  right: BorderSide(
                                      width: 1,
                                      color:
                                          controller.isselected.value != "true"
                                              ? Color.fromRGBO(221, 78, 75, 1)
                                              : Colors.black.withOpacity(0.2)),
                                  top: BorderSide(
                                      width: 1,
                                      color:
                                          controller.isselected.value != "true"
                                              ? Color.fromRGBO(221, 78, 75, 1)
                                              : Colors.black.withOpacity(0.2))),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          child: Center(
                            child: TextView(
                              text: "Completed".toUpperCase(),
                              maxLines: 1,
                              textStyle: textStyleDisplayMedium()!.copyWith(
                                color: controller.isselected.value != "true"
                                    ? Colors.white
                                    : Colors.black.withOpacity(0.3),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ).marginOnly(top: 20),
                      )
                    ],
                  ),
                  (controller.notificationResponse.value?.notification.length ??
                              0) >
                          0
                      ? Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              // Call your refresh function here
                              await controller
                                  .getNotification(); // already defined!
                            },
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: controller.notificationResponse.value
                                      ?.notification?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                var item = controller.notificationResponse.value
                                    ?.notification?[index];
                                DateTime? notificationTime;
                                final timestamp = item
                                    .createdAt; // Update this based on your Notification class
                                if (timestamp != null) {
                                  if (timestamp is String) {
                                    notificationTime =
                                        DateTime.tryParse(timestamp);
                                  } else if (timestamp is int) {
                                    notificationTime =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            timestamp);
                                  } else if (timestamp is DateTime) {
                                    notificationTime = timestamp;
                                  }
                                }

                                String displayTimeAgo = "just now";
                                if (notificationTime != null) {
                                  displayTimeAgo =
                                      formatTimeAgo(notificationTime);
                                }
                                return Container(
                                  height:
                                      Get.height * 0.14, // 15% of screen height
                                  margin: EdgeInsets.symmetric(
                                    horizontal: Get.width * 0.025,
                                  ),
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image: AssetImage(imageBackgroundProfile),
                                      fit: BoxFit.cover,
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        Get.width * 0.045),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: Get.height * 0.05,
                                            width: Get.width * 0.1,
                                            decoration: BoxDecoration(
                                              color: avatarColors[
                                                  index % avatarColors.length],
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Get.width * 0.075),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "M",
                                                style: textStyleDisplayMedium()!
                                                    .copyWith(
                                                  color: avatarColors[index %
                                                          avatarColors.length]
                                                      .withOpacity(1.0),
                                                  fontSize: Get.width * 0.035,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: Get.width * 0.03),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: Get.width * 0.45,
                                                child: Text(
                                                  item?.message ?? "",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      textStyleDisplayMedium()!
                                                          .copyWith(
                                                    color: Colors.black,
                                                    fontSize: Get.width * 0.035,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: Get.width * 0.45,
                                                child: Text(
                                                  "Ambulance Num: ${item?.ambulanceNum ?? ""}",
                                                  maxLines: 1,
                                                  style:
                                                      textStyleDisplayMedium()!
                                                          .copyWith(
                                                    color: Colors.black
                                                        .withOpacity(0.4),
                                                    fontSize: Get.width * 0.03,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: Get.width * 0.45,
                                                child: Text(
                                                  "Distance: ${double.tryParse(item?.distance ?? "0")?.toStringAsFixed(2) ?? "0.00"} Km away",
                                                  maxLines: 1,
                                                  style:
                                                      textStyleDisplayMedium()!
                                                          .copyWith(
                                                    color: Colors.black
                                                        .withOpacity(0.4),
                                                    fontSize: Get.width * 0.03,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ).marginOnly(left: 20),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          AssetImageWidget(
                                            iconAmbulances,
                                            imageHeight: Get.width * 0.075,
                                            imageWidth: Get.width * 0.175,
                                            imageFitType: BoxFit.contain,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            displayTimeAgo,
                                            style: textStyleDisplayMedium()!
                                                .copyWith(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontSize: Get.width * 0.028,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ).marginSymmetric(horizontal: 10),
                                    ],
                                  ).paddingSymmetric(
                                      horizontal: Get.width * 0.03),
                                );
                              },
                            ),
                          ),
                        )
                      : Expanded(
                          child: Center(
                              child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AssetImageWidget(
                              "assets/icons/abulance.png",
                              imageHeight: 100,
                              imageWidth: 100,
                            ).marginSymmetric(vertical: 10),
                            TextView(
                              text: "No Ambulance Found Nearby",
                              maxLines: 1,
                              textStyle: textStyleDisplayMedium()!.copyWith(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )))
                ],
              ),
            )),
      ],
    );
  }

  Widget _buttonWidget() {
    return CustomMaterialButton(
      bgColor: Color.fromRGBO(221, 78, 75, 1),
      textColor: Colors.white,
      borderRadius: 30,
      onTap: () {
        Get.toNamed(AppRoutes.profileRoute);
      },
      buttonText: "Go Profile",
    ).marginSymmetric(horizontal: 60, vertical: 20);
  }

  Widget _bodyWidget(HomeUserController controller) {
    return
        // (controller.notificationResponse.value?.notification.length??0)<0
        _bodyList(controller);
    //   Container(
    //       color: Colors.white,
    //       height: Get.height,
    //       width: Get.width,
    //       child: SafeArea(
    //         child: Column(
    //           children: [
    //             Container(
    //               decoration: BoxDecoration(
    //                 image: DecorationImage(
    //                   image: AssetImage(imageBackgroundProfile),
    //                   fit: BoxFit.fill,
    //                 ),
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.circular(18),
    //               ),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   TextView(
    //                     text: "Welcome, John",
    //                     maxLines: 1,
    //                     textStyle: textStyleDisplayMedium()!.copyWith(
    //                       color: Color.fromRGBO(221, 78, 75, 1),
    //                       fontSize: 16,
    //                       fontWeight: FontWeight.w600,
    //                     ),
    //                   ).marginSymmetric(horizontal: 15),
    //                   GestureDetector(
    //                     onTap: () {
    //                       Get.toNamed(AppRoutes.profileRoute);
    //                     },
    //                     child: Container(
    //                       height: 40,
    //                       width: 40,
    //                       decoration: BoxDecoration(
    //                         color: Color.fromRGBO(221, 78, 75, 1),
    //                         borderRadius: BorderRadius.circular(30),
    //                       ),
    //                       child: Center(
    //                         child: TextView(
    //                           text: "JD",
    //                           maxLines: 1,
    //                           textStyle: textStyleDisplayMedium()!.copyWith(
    //                             color: Colors.white,
    //                             fontSize: 10,
    //                             fontWeight: FontWeight.w600,
    //                           ),
    //                         ),
    //                       ),
    //                     ).marginAll(10),
    //                   ),
    //                 ],
    //               ).paddingSymmetric(
    //                 horizontal: margin_20,
    //                 vertical: margin_10,
    //               ),
    //             ).marginSymmetric(vertical: 10),
    //             Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 AssetImageWidget(
    //                   "assets/icons/abulance.png",
    //                   imageHeight: 100,
    //                   imageWidth: 100,
    //                 ).marginSymmetric(vertical: 10),
    //                 TextView(
    //                   text: "No Ambulance Found Nearby",
    //                   maxLines: 1,
    //                   textStyle: textStyleDisplayMedium()!.copyWith(
    //                     color: Colors.black,
    //                     fontSize: 14,
    //                     fontWeight: FontWeight.w600,
    //                   ),
    //                 ),
    //                 TextView(
    //                   text:
    //                       "Ut integer enim aliquam sit neque sed gravida ultrices. Nunc tristique duis sed gravida at. Sollicitudin facilisi",
    //                   maxLines: 4,
    //                   textAlign: TextAlign.center,
    //                   textStyle: textStyleDisplayMedium()!.copyWith(
    //                     color: Colors.black,
    //                     fontSize: 13,
    //                     fontWeight: FontWeight.w400,
    //                   ),
    //                 ).marginSymmetric(
    //                   horizontal: margin_30,
    //                   vertical: margin_10,
    //                 ),
    //               ],
    //             ).marginOnly(top: Get.height * 0.18),
    //           ],
    //         ).marginSymmetric(vertical: 10),
    //       ),
    //     );
  }
}
