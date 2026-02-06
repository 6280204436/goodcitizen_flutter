import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart' as loc;

import '../../../common_data.dart';
import '../../../export.dart';

bool hasAskedPermission = false;

Future<bool> _handleLocationPermission({showSnack = false}) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    if (hasAskedPermission == false) {
      permission = await Geolocator.requestPermission();
      hasAskedPermission = true;
      if (showSnack) {
        showSnackBar(message: keyLocService1.tr);
      }
    }

    return false;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      if (showSnack) {
        showSnackBar(message: keyLocService2.tr);
      }

      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    if (showSnack) {
      showSnackBar(message: keyLocService3.tr);
    }
    return false;
  }
  return true;
}

Future<void> _onLocationDisabled() async {
  // showCupertinoModalPopup<void>(
  //   context: Get.context!,
  //   builder: (BuildContext context) => CupertinoAlertDialog(
  //     content: TextView(
  //       text:
  //           'Turn On Location Services to Allow "Powerking" to Determine Your Location',
  //       textStyle: textStyleTitleSmall(),
  //       maxLines: 10,
  //     ),
  //     actions: <CupertinoDialogAction>[
  //       CupertinoDialogAction(
  //         onPressed: () {
  //           Get.back();
  //           Geolocator.openLocationSettings();
  //           // AppSettings.openAppSettings(type: AppSettingsType.location);
  //         },
  //         child: TextView(
  //           text: 'Settings',
  //           textStyle: textStyleTitleSmall()!.copyWith(color: Colors.blueAccent),
  //         ),
  //       ),
  //       CupertinoDialogAction(
  //         onPressed: () {
  //           Get.back();
  //         },
  //         isDefaultAction: true,
  //         child: TextView(
  //           text: 'Cancel',
  //           textStyle: textStyleTitleSmall()!.copyWith(
  //               color: Colors.blueAccent, fontWeight: FontWeight.w600),
  //         ),
  //       ),
  //     ],
  //   ),
  // );

  await Get.dialog(

      barrierColor: Colors.black.withOpacity(0.15),
      Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        constraints: BoxConstraints(maxWidth: Get.width * 0.8),
        decoration: BoxDecoration(
            color: whiteAppColor,
            borderRadius: BorderRadius.circular(radius_8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextView(
                text: keyLocNotDetected.tr,
                maxLines: 2,
                textStyle: textStyleTitleLarge()!.copyWith(
                  fontWeight: FontWeight.w600,
                )).paddingOnly(top: margin_6),
            TextView(
                    text: keyPlsTurnOnLocService.tr,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    textStyle: textStyleBodyLarge()
                        !.copyWith(fontWeight: FontWeight.w500))
                .paddingOnly(top: margin_6, bottom: margin_8),
            _rowIconWidget(
                icon: icIosSettings, text: '1. ${keyOpenTheSettingsApps.tr}'),
            _rowIconWidget(
                icon: icIosPrivacy, text: '2. ${keySelectPrivacy.tr}'),
            _rowIconWidget(
                icon: icIosLocation, text: '3. ${keySelectLocationServ.tr}'),
            _rowIconWidget(
                    icon: icIosToggle, text: '4. ${keyTurnLocService.tr}')
                .paddingOnly(bottom: margin_4),
            CustomMaterialButton(
              onTap: () {
                Get.back();
                Geolocator.openLocationSettings();
              },
              buttonText: keyGoToSettings.tr,
              buttonHeight: height_34,
            )
          ],
        ).paddingSymmetric(vertical: margin_12, horizontal: margin_12),
      ),
    ],
  ));
}

Widget _rowIconWidget({String? icon, String? text}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        flex: 2,
        child: Align(
          alignment: Alignment.centerRight,
          child: AssetImageWidget(icon ?? '',
              imageHeight: height_28, imageWidth: height_28),
        ),
      ),
      Expanded(
        flex: 8,
        child: TextView(
          text: text ?? '',
          textStyle: textStyleBodyLarge()!.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.left,
        ).paddingOnly(left: margin_5),
      )
    ],
  ).paddingOnly(bottom: margin_7);
}

Future<Position?> getCurrentPosition(
    {showLoader = true,bool showLocDialog = false}) async {
  final hasPermission =
      await _handleLocationPermission(showSnack: showLocDialog);
  if (!hasPermission && showLocDialog && Platform.isIOS) {
    await _onLocationDisabled();
    return null;
  } else {
    return await _loadLocation(showLoader: showLoader,showDialog: showLocDialog);
  }

  // loc.Location location =  loc.Location();
  //
  // bool _serviceEnabled;
  // loc.PermissionStatus _permissionGranted;
  // loc.LocationData _locationData;
  //
  // _serviceEnabled = await location.serviceEnabled();
  // if (!_serviceEnabled) {
  //   _serviceEnabled = await location.requestService();
  //   if (!_serviceEnabled) {
  //     return null;
  //   }
  // }
  //
  // _permissionGranted = await location.hasPermission();
  // if (_permissionGranted == loc.PermissionStatus.denied) {
  //   _permissionGranted = await location.requestPermission();
  //   if (_permissionGranted != loc.PermissionStatus.granted) {
  //     return null;
  //   }
  // }
  //
  // _locationData = await location.getLocation();
}

Future<Position?> _loadLocation({showLoader,bool showDialog=true}) async {
  Position? position;

  final serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    if(showDialog)
      {
        showSnackBar(message: keyLocService1.tr);
      }

    return null;
  }

  if (showLoader) customLoader.show(Get.overlayContext!);

  try {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  } catch (e) {
    callPrinter('Error getting location: $e');
  } finally {
    if (showLoader) customLoader.hide();
  }
  return position;
}

/// fetch using location package
// Future<bool> _handleLocationPermission({showSnack = false}) async {
//   loc.Location location = loc.Location();
//   bool serviceEnabled;
//   loc.PermissionStatus permission;
//
//   serviceEnabled = await location.serviceEnabled();
//
//   if (!serviceEnabled) {
//     serviceEnabled = await location.requestService();
//     if (showSnack) {
//       showSnackBar(message: keyLocService1.tr);
//     }
//     return false;
//   }
//
//   permission = await location.hasPermission();
//   if (permission == loc.PermissionStatus.denied) {
//     serviceEnabled = await location.requestService();
//     permission = await location.hasPermission();
//     if (permission == loc.PermissionStatus.denied) {
//       if (showSnack) {
//         showSnackBar(message: keyLocService2.tr);
//       }
//
//       return false;
//     }
//   }
//   if (permission == loc.PermissionStatus.deniedForever) {
//     if (showSnack) {
//       showSnackBar(message: keyLocService3.tr);
//     }
//     return false;
//   }
//   return true;
// }
//
// Future<void> _onLocationDisabled() async {
//   // showCupertinoModalPopup<void>(
//   //   context: Get.context!,
//   //   builder: (BuildContext context) => CupertinoAlertDialog(
//   //     content: TextView(
//   //       text:
//   //           'Turn On Location Services to Allow "Powerking" to Determine Your Location',
//   //       textStyle: textStyleTitleSmall(),
//   //       maxLines: 10,
//   //     ),
//   //     actions: <CupertinoDialogAction>[
//   //       CupertinoDialogAction(
//   //         onPressed: () {
//   //           Get.back();
//   //           Geolocator.openLocationSettings();
//   //           // AppSettings.openAppSettings(type: AppSettingsType.location);
//   //         },
//   //         child: TextView(
//   //           text: 'Settings',
//   //           textStyle: textStyleTitleSmall()!.copyWith(color: Colors.blueAccent),
//   //         ),
//   //       ),
//   //       CupertinoDialogAction(
//   //         onPressed: () {
//   //           Get.back();
//   //         },
//   //         isDefaultAction: true,
//   //         child: TextView(
//   //           text: 'Cancel',
//   //           textStyle: textStyleTitleSmall()!.copyWith(
//   //               color: Colors.blueAccent, fontWeight: FontWeight.w600),
//   //         ),
//   //       ),
//   //     ],
//   //   ),
//   // );
//
//   await Get.dialog(Column(
//     mainAxisSize: MainAxisSize.min,
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Container(
//         constraints: BoxConstraints(maxWidth: Get.width * 0.8),
//         decoration: BoxDecoration(
//             color: whiteAppColor,
//             borderRadius: BorderRadius.circular(radius_8)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             TextView(
//                 text: keyLocNotDetected.tr,
//                 maxLines: 2,
//                 textStyle: textStyleTitleLarge()!.copyWith(
//                   fontWeight: FontWeight.w600,
//                 )).paddingOnly(top: margin_6),
//             TextView(
//                     text: keyPlsTurnOnLocService.tr,
//                     maxLines: 3,
//                     textAlign: TextAlign.center,
//                     textStyle: textStyleBodyLarge()
//                         .copyWith(fontWeight: FontWeight.w500))
//                 .paddingOnly(top: margin_6, bottom: margin_8),
//             _rowIconWidget(
//                 icon: icIosSettings, text: '1. ${keyOpenTheSettingsApps.tr}'),
//             _rowIconWidget(
//                 icon: icIosPrivacy, text: '2. ${keySelectPrivacy.tr}'),
//             _rowIconWidget(
//                 icon: icIosLocation, text: '3. ${keySelectLocationServ.tr}'),
//             _rowIconWidget(
//                     icon: icIosToggle, text: '4. ${keyTurnLocService.tr}')
//                 .paddingOnly(bottom: margin_4),
//             CustomMaterialButton(
//               onTap: () {
//                 Get.back();
//                 openAppSettings();
//               },
//               buttonText: keyGoToSettings.tr,
//               buttonHeight: height_34,
//             )
//           ],
//         ).paddingSymmetric(vertical: margin_12, horizontal: margin_12),
//       ),
//     ],
//   ));
// }
//
// Widget _rowIconWidget({String? icon, String? text}) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Expanded(
//         flex: 2,
//         child: Align(
//           alignment: Alignment.centerRight,
//           child: AssetImageWidget(icon ?? '',
//               imageHeight: height_28, imageWidth: height_28),
//         ),
//       ),
//       Expanded(
//         flex: 8,
//         child: TextView(
//           text: text ?? '',
//           textStyle: textStyleBodyLarge()!.copyWith(fontWeight: FontWeight.w500),
//           textAlign: TextAlign.left,
//         ).paddingOnly(left: margin_5),
//       )
//     ],
//   ).paddingOnly(bottom: margin_7);
// }
//
// Future<loc.LocationData?> getCurrentPosition(
//     {showLoader = true, showLocDialog = false}) async {
//   final hasPermission =
//       await _handleLocationPermission(showSnack: !showLocDialog);
//   if (!hasPermission && showLocDialog && Platform.isIOS) {
//     await _onLocationDisabled();
//     return null;
//   } else {
//     return await _loadLocation(showLoader: showLoader);
//   }
//
//   // loc.Location location =  loc.Location();
//   //
//   // bool _serviceEnabled;
//   // loc.PermissionStatus _permissionGranted;
//   // loc.LocationData _locationData;
//   //
//   // _serviceEnabled = await location.serviceEnabled();
//   // if (!_serviceEnabled) {
//   //   _serviceEnabled = await location.requestService();
//   //   if (!_serviceEnabled) {
//   //     return null;
//   //   }
//   // }
//   //
//   // _permissionGranted = await location.hasPermission();
//   // if (_permissionGranted == loc.PermissionStatus.denied) {
//   //   _permissionGranted = await location.requestPermission();
//   //   if (_permissionGranted != loc.PermissionStatus.granted) {
//   //     return null;
//   //   }
//   // }
//   //
//   // _locationData = await location.getLocation();
// }
//
// Future<loc.LocationData?> _loadLocation({showLoader}) async {
//   loc.Location location = loc.Location();
//   loc.LocationData? locationData;
//   if (showLoader) customLoader.show(Get.overlayContext!);
//   try {
//     locationData = await location.getLocation();
//   } catch (e) {
//     callPrinter('Error getting location: $e');
//   } finally {
//     if (showLoader) customLoader.hide();
//   }
//   return locationData;
// }
