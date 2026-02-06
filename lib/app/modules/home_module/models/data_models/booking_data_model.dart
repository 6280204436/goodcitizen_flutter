import '../../../../core/values/app_constants.dart';
import '../../../authentication/models/data_model/user_model.dart';
import '../../../profile/models/address_data_model.dart';

class BookingDataModel {
  String? sId;
  UserDataModel? customerId;
  UserDataModel? driverId;
  String? bookingId;
  // VehicleTypeModel? vehicleId;
  // VehicleDetailModel? vehicleDetail;
  String? pickupAddress;
  String? dropAddress;
  double? pickupLat;
  double? pickupLong;
  double? dropLat;
  double? dropLong;
  List<AddressDataModel>? stops;
  var arrivedAtStop1;
  var startedFromStop1;
  var arrivedAtStop2;
  var startedFromStop2;
  var scheduleDate;
  String? bookingStatus;
  String? bookingType;
  String? rideStatus;
  var cancelledReason;
  var cancelledBy;
  String? paymentMethod;
  var paymentStatus;
  num? distanceInKm;
  num? baseFee;
  num? stopCharges;
  num? surchargeAmount;
  num? tollPrice;
  num? tipDriver;
  num? gst;
  num? couponDiscount;
  num? totalAmount;
  num? baseFeeWithDiscount;

  var extimatedDeliveryTime;
  int? startRideAt;
  int? completeDeliveryAt;

  // List<Comf>? filter;
  int? createdAt;
  var updatedAt;
  int? iV;
  bool? paymentConfirmed;
  bool? paymentReceived;

  bool? ratedByCustomer;
  bool? ratedByDriver;
  String? dispatcherId;
  bool? isRideStarted;


  String? requestType;
  ///related to parcel
  String? senderName;
  String? senderNumber;
  String? senderCountryCode;
  String? receiverName;
  String? receiverNumber;
  String? receiverCountryCode;
  String? parcelInfo;
  num? driverEarning;

  BookingDataModel(
      {this.sId,
      this.customerId,
      this.bookingId,
      // this.vehicleId,
      this.pickupAddress,
      this.dropAddress,
      this.pickupLat,
      this.pickupLong,
      this.dropLat,
      this.dropLong,
      this.stops,
      this.arrivedAtStop1,
      this.startedFromStop1,
      this.arrivedAtStop2,
      this.startedFromStop2,
      this.scheduleDate,
      this.bookingStatus,
      this.bookingType,
      this.rideStatus,
      this.cancelledReason,
      this.cancelledBy,
      this.paymentMethod,
      this.paymentStatus,
      this.distanceInKm,
      this.baseFee,
      this.stopCharges,
      this.surchargeAmount,
      this.tollPrice,
      this.tipDriver,
      this.gst,
      this.couponDiscount,
      this.totalAmount,
      this.extimatedDeliveryTime,
      this.completeDeliveryAt,
      // this.filter,
      this.createdAt,
      this.updatedAt,
      this.iV});

  BookingDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    requestType =json['request_type']??requestTypeRide;
    customerId = json['customer_id'] != null
        ? json['customer_id'] is String
            ? UserDataModel(sId: json['customer_id'])
            : UserDataModel.fromJson(json['customer_id'])
        : null;
    bookingId = json['booking_id'];
    // vehicleId = json['vehicle_id'] != null
    //     ? json['vehicle_id'] is String
    //         ? VehicleTypeModel(sId: json['vehicle_id'])
    //         : VehicleTypeModel.fromJson(json['vehicle_id'])
    //     : null;
    // vehicleDetail = json['vehicleDetail_id'] != null
    //     ? json['vehicleDetail_id'] is String
    //         ? VehicleDetailModel(sId: json['vehicleDetail_id'])
    //         : VehicleDetailModel.fromJson(json['vehicleDetail_id'])
    //     : null;
    driverId = json['driver_id'] != null
        ? json['driver_id'] is String
            ? UserDataModel(sId: json['driver_id'])
            : UserDataModel.fromJson(json['driver_id'])
        : null;
    ratedByCustomer = json['rate_by_customer'];
    ratedByDriver = json['rate_by_driver'];
    isRideStarted = json['is_ride_started'];
    paymentConfirmed = json['payment_confirmed'];
    paymentReceived = json['payment_received'];
    pickupAddress = json['pickup_address'];
    dropAddress = json['drop_address'];
    pickupLat = json['pickup_lat'] is String
        ? double.parse(json['pickup_lat'])
        : json['pickup_lat'];
    pickupLong = json['pickup_long'] is String
        ? double.parse(json['pickup_long'])
        : json['pickup_long'];
    dropLat = json['drop_lat'] is String
        ? double.parse(json['drop_lat'])
        : json['drop_lat'];
    dropLong = json['drop_long'] is String
        ? double.parse(json['drop_long'])
        : json['drop_long'];
    if (json['stops'] != null) {
      stops = <AddressDataModel>[];
      json['stops'].forEach((v) {
        stops!.add(AddressDataModel.fromJson(v));
      });
    }
    arrivedAtStop1 = json['arrived_at_stop_1'];
    startedFromStop1 = json['started_from_stop_1'];
    arrivedAtStop2 = json['arrived_at_stop_2'];
    startedFromStop2 = json['started_from_stop_2'];
    scheduleDate = json['schedule_date'];
    bookingStatus = json['booking_status'];
    bookingType = json['booking_type'];
    rideStatus = json['ride_status'];
    cancelledReason = json['cancelled_reason'];
    cancelledBy = json['cancelled_by'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    distanceInKm = json['distance_in_km'];
    baseFee = json['base_fee'];
    driverEarning = json['driver_earning'];
    baseFeeWithDiscount = json['base_fee_with_discount'] == 0
        ? null
        : json['base_fee_with_discount'];
    stopCharges = json['stop_charges'] == 0 ? null : json['stop_charges'];
    surchargeAmount =
        json['surcharge_amount'] == 0 ? null : json['surcharge_amount'];
    tollPrice = json['toll_price'] == 0 ? null : json['toll_price'];
    tipDriver = json['tip_driver'] == 0 ? null : json['tip_driver'];
    gst = json['gst'];
    couponDiscount = json['coupon_discount'];
    totalAmount = json['total_amount'];
    extimatedDeliveryTime = json['extimated_delivery_time'];
    startRideAt = json['start_ride_at'];
    completeDeliveryAt = json['complete_delivery_at'];
    // if (json['filter'] != null) {
    //   filter = <Null>[];
    //   json['filter'].forEach((v) {
    //     filter!.add(new Null.fromJson(v));
    //   });
    // }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    dispatcherId = json['dispatcher_id'];
    senderName =json['sender_name'];
    senderCountryCode = json['sender_country_code'];
    senderNumber =json['sender_number'];
    receiverName =  json['receiver_name'];
    receiverCountryCode = json['receiver_country_code'];
    receiverNumber = json['receiver_number'];
    parcelInfo = json['parcel_details'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.customerId != null) {
      data['customer_id'] = this.customerId!.toJson();
    }
    data['booking_id'] = this.bookingId;
    // if (this.vehicleId != null) {
    //   data['vehicle_id'] = this.vehicleId!.toJson();
    // }
    data['pickup_address'] = this.pickupAddress;
    data['drop_address'] = this.dropAddress;
    data['pickup_lat'] = this.pickupLat;
    data['pickup_long'] = this.pickupLong;
    data['drop_lat'] = this.dropLat;
    data['drop_long'] = this.dropLong;
    if (this.stops != null) {
      data['stops'] = this.stops!.map((v) => v.toJson()).toList();
    }
    data['arrived_at_stop_1'] = this.arrivedAtStop1;
    data['started_from_stop_1'] = this.startedFromStop1;
    data['arrived_at_stop_2'] = this.arrivedAtStop2;
    data['started_from_stop_2'] = this.startedFromStop2;
    data['schedule_date'] = this.scheduleDate;
    data['booking_status'] = this.bookingStatus;
    data['booking_type'] = this.bookingType;
    data['ride_status'] = this.rideStatus;
    data['cancelled_reason'] = this.cancelledReason;
    data['cancelled_by'] = this.cancelledBy;
    data['payment_method'] = this.paymentMethod;
    data['payment_status'] = this.paymentStatus;
    data['distance_in_km'] = this.distanceInKm;
    data['base_fee'] = this.baseFee;
    data['stop_charges'] = this.stopCharges;
    data['surcharge_amount'] = this.surchargeAmount;
    data['toll_price'] = this.tollPrice;
    data['tip_driver'] = this.tipDriver;
    data['gst'] = this.gst;
    data['coupon_discount'] = this.couponDiscount;
    data['total_amount'] = this.totalAmount;
    data['extimated_delivery_time'] = this.extimatedDeliveryTime;
    data['complete_delivery_at'] = this.completeDeliveryAt;
    // if (this.filter != null) {
    //   data['filter'] = this.filter!.map((v) => v.toJson()).toList();
    // }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
