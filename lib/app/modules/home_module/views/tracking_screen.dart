import 'package:avatar_glow/avatar_glow.dart';
import 'package:good_citizen/app/modules/home_module/controllers/tracking_controller.dart';
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

class TrackingScreen extends GetView<TrackingController> {
  // late HomeController controller;

  TrackingScreen({super.key}) {
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
         
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          body:_bodyWidget(),
        )));
  }

  Widget _bodyWidget() {
    return  SizedBox(
      height: Get.height,
      width: Get.width,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          
          _mapWidget(),
          


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
                isActiveTrip: true,
                zoom: initialMapZoom,
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,

                markers: controller.routeMarkers.values.toSet(),
                mapId: controller.completer.future
                    .then<int>((value) => value.mapId),
                child:GetBuilder<TrackingController>(
                    builder: (controller) {
                      return  GoogleMap(
                      mapType: MapType.normal,
                      myLocationEnabled: false,
                      polylines: Set<Polyline>.of(controller.routePolylines.values),
                      style: Get.find<ThemeController>().getMapTheme(),
                      onTap: controller.onMapTap,
                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer(),
                        ),
                      },
                      myLocationButtonEnabled: false,
                      onCameraMove: controller.onCameraMove,
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: true,

                      initialCameraPosition: controller.initialCameraPosition,
                      onMapCreated: controller.onMapCreated);
                })
              ),

              _profileLocationIcons().marginOnly(bottom:margin_40 ),
                       ],
          ),
        ),
      ],
    );
  }

  Widget _profileLocationIcons() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SafeArea(
            child:Container(
              decoration: BoxDecoration(
                // image:DecorationImage(image:AssetImage(imageBackgroundProfile,),fit: BoxFit.fill),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18)),
              child:  GestureDetector(onTap: (){
                Get.back();
              },child: Container(height: 40,width: 40,child: Center(child: Icon(Icons.arrow_back,color: Colors.black,)))),


            ).marginSymmetric( vertical: 10),

          ),
          SizedBox(

            width: Get.width,
            child: Stack(
              alignment: Alignment.topLeft,
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


}
