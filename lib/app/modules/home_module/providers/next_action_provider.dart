import 'package:good_citizen/app/core/values/app_constants.dart';
import 'package:good_citizen/app/modules/home_module/models/data_models/booking_data_model.dart';

enum BookingNextActionsEnum {
  reachedPickup,
  startRide,
  reachedStopOne,
  startedFromStopOne,
  reachedStopTwo,
  startedFromStopTwo,
  completeRide,
  invalid
}


BookingNextActionsEnum nextActionProvider(BookingDataModel? bookingDataModel) {
  if (bookingDataModel?.rideStatus == null) {

    return BookingNextActionsEnum.reachedPickup;
  } else if (bookingDataModel?.rideStatus == rideStateAtPickup) {
    return BookingNextActionsEnum.startRide;
  } else if (bookingDataModel?.rideStatus == rideStateAtStartRide &&
      (bookingDataModel?.stops?.length ?? 0) > 0) {
    return BookingNextActionsEnum.reachedStopOne;
  } else if (bookingDataModel?.rideStatus == rideStateAtStopOne &&
      (bookingDataModel?.stops?.length ?? 0) > 0) {
    return BookingNextActionsEnum.startedFromStopOne;
  } else if (bookingDataModel?.rideStatus == rideStateFromStopOne &&
      (bookingDataModel?.stops?.length ?? 0) > 1) {
    return BookingNextActionsEnum.reachedStopTwo;
  } else if (bookingDataModel?.rideStatus == rideStateAtStopTwo &&
      (bookingDataModel?.stops?.length ?? 0) > 1) {
    return BookingNextActionsEnum.startedFromStopTwo;
  } else if (bookingDataModel?.rideStatus == rideStateFromStopTwo ||
      bookingDataModel?.rideStatus == rideStateFromStopOne ||
      bookingDataModel?.rideStatus == rideStateAtStartRide) {
    return BookingNextActionsEnum.completeRide;
  } else {
    return BookingNextActionsEnum.invalid;
  }
}
