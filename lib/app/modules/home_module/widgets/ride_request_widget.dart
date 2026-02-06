// import 'package:good_citizen/app/common_data.dart';
// import 'package:good_citizen/app/core/utils/common_methods.dart';
// import 'package:good_citizen/app/core/widgets/network_image_widget.dart';
// import 'package:good_citizen/app/modules/home_module/controllers/home_controller.dart';
//
// import '../../../core/external_packages/another_stepper.dart/dto/stepper_data.dart';
// import '../../../core/external_packages/another_stepper.dart/widgets/another_stepper.dart';
// import '../../../core/external_packages/count_down_timer/circular_countdown_timer.dart';
// import '../../../core/utils/show_bottom_sheet.dart';
// import '../../../export.dart';
// // import '../../ongoing_ride/widgets/booking_stepper_widget.dart';
//
// class RideRequestWidget extends StatelessWidget {
//   final HomeController controller;
//   final int timer;
//
//   const RideRequestWidget(
//       {super.key, required this.controller, this.timer = 30});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => _itemsList());
//   }
//
//   Widget _itemsList() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _userCard().paddingOnly(bottom: margin_14, top: margin_18),
//         _timerWidget().paddingOnly(bottom: margin_14),
//         // _stepperWidget().paddingOnly(bottom: margin_14),
//         _priceDetail().paddingOnly(bottom: margin_16),
//         _buttons().paddingOnly(bottom: margin_12, top: margin_6),
//       ],
//     ).paddingSymmetric(horizontal: margin_15);
//   }
//
//   Widget _userCard() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           decoration: const BoxDecoration(
//               shape: BoxShape.circle, color: AppColors.appGreyColorDark),
//           child: NetworkImageWidget(
//             imageUrl:
//                 controller.rideRequestModel.value?.customerId?.image ?? '',
//             imageHeight: height_36,
//             imageWidth: height_36,
//             placeHolder: userPlaceholder,
//             radiusAll: radius_40,
//           ).paddingAll(margin_2),
//         ).marginOnly(right: margin_7),
//         Expanded(
//             child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Flexible(
//                     child: TextView(
//                         text: controller
//                                 .rideRequestModel.value?.customerId?.name ??
//                             '',
//                         maxLines: 2,
//                         textStyle: textStyleTitleLarge()!
//                             .copyWith(fontWeight: FontWeight.w500))),
//                 Visibility(
//                     visible: (controller
//                                 .rideRequestModel.value?.customerId?.ratings ??
//                             0) >
//                         0,
//                     child: _userRatingCard().paddingOnly(left: margin_7)),
//               ],
//             ),
//             TextView(
//                     text: getPaymentMethodDetail(controller
//                                 .rideRequestModel.value?.paymentMethod)
//                             .title ??
//                         '',
//                     textStyle: textStyleTitleSmall()!.copyWith(
//                         color: AppColors.textGreyColor,
//                         fontWeight: FontWeight.w400))
//                 .paddingOnly(top: margin_1point5)
//           ],
//         )),
//       ],
//     );
//   }
//
//   Widget _userRatingCard() {
//     return Container(
//       decoration: BoxDecoration(
//           color:
//               isDarkMode.value ? AppColors.whiteLight : AppColors.appGreyColor,
//           borderRadius: BorderRadius.circular(radius_3)),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Flexible(
//               child: TextView(
//                       text: controller
//                               .rideRequestModel.value?.customerId?.ratings
//                               ?.toString() ??
//                           '',
//                       textStyle: textStyleTitleSmall()!
//                           .copyWith(fontWeight: FontWeight.w400))
//                   .paddingOnly(right: margin_2)),
//           AssetSVGWidget(
//             icStar,
//             imageWidth: height_14,
//             imageHeight: height_14,
//           )
//         ],
//       ).paddingSymmetric(horizontal: margin_6, vertical: margin_2),
//     );
//   }
//
//   Widget _timerWidget() {
//     return CircularCountDownTimer(
//       duration: timer,
//       initialDuration: 0,
//       controller: CountDownController(),
//       width: height_85,
//       height: height_85,
//       ringColor: AppColors.appGreyColor,
//       ringGradient: null,
//       fillColor: AppColors.appGreenColor,
//       fillGradient: null,
//       backgroundGradient: null,
//       strokeWidth: height_4,
//       strokeCap: StrokeCap.round,
//       textStyle: textStyleDisplayLarge()!.copyWith(
//           fontWeight: FontWeight.w400,
//           fontSize: font_30,
//           color: AppColors.textGreyColorDark),
//       textFormat: CountdownTextFormat.S,
//       isReverse: true,
//       isReverseAnimation: true,
//       isTimerTextShown: true,
//       autoStart: true,
//       onStart: controller.onNewRequestWidget,
//       onComplete: controller.onNewRequestWidgetHide,
//       onChange: controller.onTimerChange,
//       timeFormatterFunction: (defaultFormatterFunction, duration) {
//         return Function.apply(defaultFormatterFunction, [duration]);
//       },
//     );
//   }
//
//   // Widget _stepperWidget() {
//   //   return BookingStepperWidget(
//   //       pickupAddress: controller.rideRequestModel.value?.pickupAddress,
//   //       destinationAddress: controller.rideRequestModel.value?.dropAddress);
//   //
//   //   // List<StepperData> stepperData = [
//   //   //   StepperData(
//   //   //       contentWidget: TextView(
//   //   //           textStyle: textStyleTitleSmall()
//   //   //               .copyWith(
//   //   //                   fontWeight: FontWeight.w400, fontSize: font_12point5)
//   //   //               .copyWith(),
//   //   //           maxLines: 2,
//   //   //           text: controller.rideRequestModel.value?.pickupAddress ?? ''),
//   //   //       iconWidget: const AssetSVGWidget(icCircleSelectedCab)),
//   //   //   StepperData(
//   //   //       contentWidget: Column(
//   //   //         children: [
//   //   //           TextView(
//   //   //               textStyle: textStyleTitleSmall()!.copyWith(
//   //   //                   fontWeight: FontWeight.w400, fontSize: font_12point5),
//   //   //               maxLines: 2,
//   //   //               text: controller.rideRequestModel.value?.dropAddress ?? ''),
//   //   //         ],
//   //   //       ),
//   //   //       iconWidget: const AssetSVGWidget(icDestination)),
//   //   // ];
//   //   //
//   //   // return AnotherStepper(
//   //   //   barThickness: margin_0point8,
//   //   //   iconHeight: height_18,
//   //   //   iconWidth: height_15,
//   //   //   verticalGap: margin_13,
//   //   //   stepperList: stepperData,
//   //   //   stepperDirection: Axis.vertical,
//   //   // );
//   // }
//
//   Widget _priceDetail() {
//     return Column(children: [
//       if (controller.rideRequestModel.value?.requestType ==
//           requestTypeParcel) ...[
//         _titleValueWidget(keyReqType, keyParcelDelivery)
//             .paddingOnly(bottom: margin_12),
//       ],
//       if (controller.rideRequestModel.value?.scheduleDate != null) ...[
//         _titleValueWidget(
//                 keyScheduleTime,
//                 rideTimeFormat(
//                     date: getDateFromMilliSec(
//                         controller.rideRequestModel.value?.scheduleDate)))
//             .paddingOnly(bottom: margin_12),
//       ],
//       _titleValueWidget(keyDistance,
//               '${controller.rideRequestModel.value?.distanceInKm}${keyKm.tr}')
//           .paddingOnly(bottom: margin_12),
//       _titleValueWidget(keyTripAmount,
//           '${profileDataProvider.userDataModel.value?.currencySymbol ?? ''}${controller.rideRequestModel.value?.totalAmount ?? controller.rideRequestModel.value?.baseFeeWithDiscount ?? controller.rideRequestModel.value?.baseFee ?? ''}'),
//     ]);
//   }
//
//   Widget _titleValueWidget(String? title, String? value,
//       {TextStyle? titleStyle, TextStyle? valueStyle}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//             flex: 5,
//             child: TextView(
//                     text: title ?? '',
//                     textAlign: TextAlign.start,
//                     textStyle: titleStyle ??
//                         textStyleTitleSmall()!.copyWith(
//                             fontWeight: FontWeight.w400,
//                             color: AppColors.textGreyColor))
//                 .paddingOnly(right: margin_8)),
//         Flexible(
//           flex: 6,
//           child: TextView(
//               text: value ?? '',
//               textAlign: TextAlign.end,
//               textStyle: valueStyle ??
//                   textStyleTitleSmall()!.copyWith(fontWeight: FontWeight.w500)),
//         )
//       ],
//     );
//   }
//
//   Widget _buttons() {
//     return SafeArea(
//       child: Row(children: [
//         Expanded(
//           child: CustomMaterialButton(
//             onTap: controller.onDeclineRide,
//             buttonHeight: height_40,
//             buttonText: keyDecline.tr,
//             //  borderColor: AppColors.redColor,
//             isOutlined: true,
//           ),
//         ),
//         SizedBox(width: height_15),
//         Expanded(
//           child: CustomMaterialButton(
//             onTap: controller.onAcceptRide,
//             buttonHeight: height_40,
//             buttonText: keyAccept.tr,
//           ),
//         ),
//       ]),
//     );
//   }
// }
