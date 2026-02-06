import 'export.dart';

class RideStatusModel {
  String status;
  String? title;
  Color? color = AppColors.appColor;

  RideStatusModel({this.title, this.status = rideStatusOngoing, this.color});
}

List<RideStatusModel> _rideStatusList = [
  RideStatusModel(
      status: bookingStatusAccepted,
      title: keyOngoing,
      color: AppColors.appColor),
  RideStatusModel(
      status: bookingStatusCompleted,
      title: keyCompleted,
      color: AppColors.appGreenColor),
  RideStatusModel(
      status: bookingStatusCancelled,
      title: keyCancelled,
      color: AppColors.appRedColor),
  RideStatusModel(
      status: bookingStatusFailed,
      title: keyFailed,
      color: AppColors.appRedColor),
];

RideStatusModel getRideStatus(String? status) {
  final index =
      _rideStatusList.indexWhere((element) => element.status == status);
  if (index != -1) {
    return _rideStatusList[index];
  }
  return _rideStatusList.first;
}
