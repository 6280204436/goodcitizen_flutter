// import '../../../export.dart';
//
// class VerificationPendingWidget extends StatelessWidget {
//   const VerificationPendingWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return _itemsList();
//   }
//
//   Widget _itemsList() {
//     return SafeArea(
//       top: true,
//       left: false,
//       right: false,
//       child: SizedBox(
//         width: Get.width,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Get.back();
//                 },
//                 child: AssetSVGWidget(
//                   icCrossShaded,color: isDarkMode.value?AppColors.whiteAppColor:Colors.black,
//                   imageWidth: height_25,
//                   imageHeight: height_25,
//                 ).paddingOnly(bottom: margin_12, top: margin_5),
//               ),
//               TextView(
//                       text: getTitle,
//                       maxLines: 2,
//                       textAlign: TextAlign.start,
//                       textStyle: textStyleTitleLarge()!.copyWith(
//                           fontWeight: FontWeight.w600, fontSize: font_17))
//                   .paddingOnly(bottom: margin_9),
//               TextView(
//                   text: getSubTitle,
//                   maxLines: 7,
//                   textAlign: TextAlign.start,
//                   textStyle: textStyleTitleSmall()!.copyWith()),
//             ],
//           ).paddingSymmetric(vertical: margin_7),
//         ),
//       ),
//     );
//   }
//
//   String get getTitle {
//     if (profileDataProvider.userDataModel.value?.isDocUpdated == true) {
//       return keyAccountUnderVerify.tr;
//     } else if (profileDataProvider.userDataModel.value?.rejectOn != null) {
//       return keyAccountRejected.tr;
//     } else if (profileDataProvider.userDataModel.value?.docExpiryType == null) {
//       return keyAccountUnderVerify.tr;
//     } else {
//       return keyDocsExpired.tr;
//     }
//   }
//
//   String get getSubTitle {
//     if (profileDataProvider.userDataModel.value?.isDocUpdated == true) {
//       return keyAccountUnderVerifyDes.tr;
//     } else if (profileDataProvider.userDataModel.value?.rejectOn != null) {
//       return keyAccountRejectedDes.tr;
//     } else if (profileDataProvider.userDataModel.value?.docExpiryType == null) {
//       return keyAccountUnderVerifyDes.tr;
//     } else if (profileDataProvider.userDataModel.value?.docExpiryType ==
//         expiryTypeDocs) {
//       return keyDocsExpiredBoth.tr;
//     } else if (profileDataProvider.userDataModel.value?.docExpiryType ==
//         expiryTypeLicence) {
//       return keyDocsExpiredLic.tr;
//     } else if (profileDataProvider.userDataModel.value?.docExpiryType ==
//         expiryTypeVehicleIns) {
//       return keyDocsExpiredVehIns.tr;
//     } else if (profileDataProvider.userDataModel.value?.docExpiryType ==
//         expiryTypeVehicleReg) {
//       return keyDocsExpiredVehReg.tr;
//     } else {
//       return keyDocsExpiredVeh.tr;
//     }
//   }
// }
