// import 'package:flutter_localization/flutter_localization.dart';
import 'package:good_citizen/app/export.dart';

import 'core/utils/common_item_model.dart';

final List<CommonItemModel> languagesList = [
  CommonItemModel(title: keyEnglish, id: 'en',),
  CommonItemModel(title: keyHindi, id: 'hi', ),
];

// CommonItemModel getSelectedLanguage() {
//   final index = languagesList.indexWhere((element) {
//     final loc = '${element.id}_${element.value}';
//     return deviceLocale.localeIdentifier == loc;
//   });
//
//   if (index != -1) {
//     return languagesList[index];
//   }
//   return languagesList[0];
//
//
// }
//
// List<VehicleTypeModel> vehicleTypeList = [];
//
// VehicleTypeModel getVehicleTypeDetail(String? vehicleTypeId) {
//   final index =
//       vehicleTypeList.indexWhere((element) => element.sId == vehicleTypeId);
//   if (index != -1) {
//     return vehicleTypeList[index];
//   }
//   if (vehicleTypeList.isNotEmpty) {
//     return vehicleTypeList[0];
//   }
//   return  VehicleTypeModel();
// }

String getMarkerImagePath(String? vehicleType) {
  switch (vehicleType?.toLowerCase()) {
    case vehicleTypeBike:
      return icBikeMarker;
    case vehicleTypeAuto:
      return icAutoMarker;
    default:
      return icCarMarker;
  }
}



//
// Future loadVehicleTypes({bool byPassCheck = false, showLoader = false}) async {
//   if (preferenceManager.getAuthToken() != null &&
//       (byPassCheck ? true : vehicleTypeList.isEmpty)) {
//     if (showLoader == true) {
//       customLoader.show(Get.context);
//     }
//
//     await repository.getVehicleTypesApiCall().then((value) async {
//       customLoader.hide();
//       if (value != null) {
//         vehicleTypeList.clear();
//         VehicleTypesResponseModel vehicleTypesResponseModel = value;
//         vehicleTypeList = vehicleTypesResponseModel.data ?? [];
//       }
//     }).onError((error, stackTrace) {
//       customLoader.hide();
//     });
//   }
// }

List<CommonItemModel> paymentMethodList = [
  CommonItemModel(
      title: keyCash,
     ),
  CommonItemModel(
      title: keyWallet, ),
  CommonItemModel(title: keyCredCard,),
];

// CommonItemModel getPaymentMethodDetail(String? type) {
//   final index =
//       paymentMethodList.indexWhere((element) => element.value == type);
//   if (index != -1) {
//     return paymentMethodList[index];
//   }
//   return paymentMethodList[0];
// }

List<CommonItemModel> rideComfortList = [
  CommonItemModel(
      title: keyChildSeatAvailability,
      id: comfortChildSeat,
     ),
  CommonItemModel(
      title: keyWheelAvailability,
      id: comfortWheelChair,
    )
];

void callPrinter(dynamic data) {
  debugPrint(data.toString());
}
