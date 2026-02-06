import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/model/lat_lng_model.dart';
import 'package:good_citizen/app/modules/profile/models/address_data_model.dart';

class AuthRequestModel {
/*===================================================Register Request Model==============================================*/
  static registerRequestModel({
    required String? phoneNumber,
    required String? countryCode,
    required String? timeZone,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["country_code"] = countryCode;
    data["phone"] = phoneNumber;
    data["type"] = userTypeDriver;
    data["timeZone"] = timeZone;
    return data;
  }

  static Map<String, dynamic> editProfile(
      {String? firstName,
      String? lastName,
      String? countryCode,
      String? phoneNumber,
      String? oldPassword,
      String? newPassword,
      String? profilePic,
      String? aadharFront,
      String? aadharBack,
      String? dlFront,
      String? dlBack,
      String? dlExpireDate,
      String? ambulanceNum,
      String? hospitalDoc,
      String? dl_num}) {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (firstName != null && firstName.isNotEmpty) {
      data["first_name"] = firstName;
    }
    if (lastName != null && lastName.isNotEmpty) {
      data["last_name"] = lastName;
    }
    if (countryCode != null && countryCode.isNotEmpty) {
      data["country_code"] = countryCode;
    }
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      data["phone_number"] = phoneNumber;
    }
    if (oldPassword != null && oldPassword.isNotEmpty) {
      data["old_password"] = oldPassword;
    }
    if (newPassword != null && newPassword.isNotEmpty) {
      data["new_password"] = newPassword;
    }
    if (profilePic != null && profilePic.isNotEmpty) {
      data["profile_pic"] = profilePic;
    }
    if (aadharFront != null && aadharFront.isNotEmpty) {
      data["aadhar_front"] = aadharFront;
    }
    if (aadharBack != null && aadharBack.isNotEmpty) {
      data["aadhar_back"] = aadharBack;
    }
    if (dlFront != null && dlFront.isNotEmpty) {
      data["dl_front"] = dlFront;
    }
    if (dlBack != null && dlBack.isNotEmpty) {
      data["dl_back"] = dlBack;
    }
    if (dl_num != null && dl_num.isNotEmpty) {
      data["dl_num"] = dl_num;
    }
    if (dlExpireDate != null && dlExpireDate.isNotEmpty) {
      data["dl_expire_date"] = dlExpireDate;
    }
    if (ambulanceNum != null && ambulanceNum.isNotEmpty) {
      data["ambulance_num"] = ambulanceNum;
    }
    if (hospitalDoc != null && hospitalDoc.isNotEmpty) {
      data["hospital_doc"] = hospitalDoc;
    }

    return data;
  }

  static socialLoginRequestModel(
      {required String? first_name,
      required String? last_name,
      required String? email,
      required String? password,
      required String? country_code,
      required String? phone_number,
      required String? lat,
      String? profile_pic,
      required String? gender,
      required String? long,
      String? role,
      String? device,
      required String? fcmToken}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["first_name"] = first_name;
    data["last_name"] = last_name;
    data["country_code"] = country_code;
    data["phone_number"] = phone_number;

    data["email"] = email;
    data["password"] = password;
    data["fcm_token"] = fcmToken;
    data["type"] = userTypeDriver;
    data["lat"] = lat;
    data["role"] = role;
    data["profile_pic"] = profile_pic;
    data["gender"] = gender;

    data["long"] = long;
    data["device_type"] = device != null
        ? device
        : Platform.isAndroid
            ? 'android'.toUpperCase()
            : Platform.isIOS
                ? 'ios'.toUpperCase()
                : 'web'.toUpperCase();
    return data;
  }

  static DriverDocuments({
    required String? aadhar_front,
    required String? aadhar_back,
    required String? dl_front,
    required String? dl_back,
    required String? dl_expire_date,
    required String? ambulance_num,
    required String? hospital_doc,
    required String? dl_num,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["aadhar_front"] = aadhar_front;
    data["aadhar_back"] = aadhar_back;
    data["dl_front"] = dl_front;
    data["dl_back"] = dl_back;
    data["dl_expire_date"] = dl_expire_date;
    data["ambulance_num"] = ambulance_num;
    data["hospital_doc"] = hospital_doc;
    data["dl_num"] = dl_num;
    return data;
  }

  static LoginRequestModel(
      {required String? email,
      required String? password,
      required String? lat,
      required String? long,
      // String? role,
      required String? fcmToken}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["email"] = email;
    data["password"] = password;
    data["fcm_token"] = fcmToken;
    // data["type"] = userTypeDriver;
    data["lat"] = lat;
    // data["role"] = role;

    data["long"] = long;
    data["device_type"] = Platform.isAndroid
        ? 'android'.toUpperCase()
        : Platform.isIOS
            ? 'ios'.toUpperCase()
            : 'web'.toUpperCase();
    return data;
  }

  static forgetPasswordRequestmodel({required String? email}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["email"] = email;
    return data;
  }

  static forgetemailVerifyRequestModel(
      {required String? otp, required String? email}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["otp"] = otp;
    data["email"] = email;

    return data;
  }

  static emailVerifyRequestModel({String? fcmtoken, required String? otp}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["otp"] = otp;
    data["fcm_token"] = fcmtoken;

    return data;
  }

/*==================================================Verify Email Request Model==============================================*/

  /*==================================================Update Profile Request Model==============================================*/
  static updateProfileRequestModel({
    String? name,
    String? description,
    String? image,
    String? gender,
    String? dob,
    String? countryCode,
    String? phone,
    String? email,
    String? language,
    String? currency,
    String? currencySymbol,
    String? licFront,
    String? licBack,
    bool? isIndividual,
    AddressDataModelOld? addressDataModel,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data["name"] = name;
    if (dob != null) data["date_of_birth"] = dob;
    if (description != null) data["bio"] = description;
    if (language != null) data["language"] = language;
    if (currency != null) data["currency"] = currency;
    if (currencySymbol != null) data["currency_symbol"] = currencySymbol;

    if (image != null) data["image"] = image;
    if (addressDataModel != null) data["address"] = addressDataModel;
    if (gender != null) data["gender"] = gender;
    if (email != null) data["email"] = email.toLowerCase();
    if (countryCode != null) data["country_code"] = countryCode;
    if (phone != null) data["phone"] = phone;
    if (isIndividual != null) data["is_individual"] = isIndividual;
    if (licBack != null) data["licence_back_image"] = licBack;
    if (licFront != null) data["licence_front_image"] = licFront;
    return data;
  }

  static forgePassRequestModel({
    required String? email,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["email"] = email?.toLowerCase();
    return data;
  }

  static setPasswordRequestModel({
    required String? password,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["password"] = password;
    return data;
  }

  static resetPassRequestModel({
    required String? password,
    required String? uniqueId,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["new_password"] = password;
    data["unique_id"] = uniqueId;

    return data;
  }

  static addCardRequestModel(
      {String? cardNo,
      String? expMonth,
      String? expYear,
      String? cvc,
      String? name}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["type"] = "card";
    data["card[number]"] = cardNo;
    data["card[exp_month]"] = expMonth;
    data["card[exp_year]"] = expYear;
    data["card[cvc]"] = cvc;
    return data;
  }

  static changePassRequestModel({
    required String? oldPass,
    required String? newPass,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["old_password"] = oldPass;
    data["new_password"] = newPass;
    return data;
  }

  static addUpdateDocRequestModel(
      {String? country, String? type, String? front, String? back}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["country"] = country;
    data["doc_type"] = type;
    data["front_image"] = front;
    data["back_image"] = back;
    return data;
  }

  static addUpdateVehicleRequestModel(
      {String? typeId,
      String? vehicleId,
      String? name,
      String? model,
      String? color,
      String? number,
      String? regDoc,
      String? insDoc,
      bool? childSeat,
      bool? wheelChair,
      List<String>? itemsEdited}) {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (vehicleId != null) data['vehicle_detail_id'] = vehicleId;
    data['vehicle_id'] = typeId;
    data['name'] = name;
    data['model'] = model;
    data['number'] = number;
    data['color'] = color;
    data['child_seat_availabilty'] = childSeat;
    data['wheel_chair_availabilty'] = wheelChair;
    data['vehicle_registration_image'] = regDoc;
    data['vehicle_insurance_image'] = insDoc;
    if (itemsEdited != null) data['edit_items'] = itemsEdited;

    return data;
  }

  static addUpdateBankRequestModel({
    String? id,
    String? firstName,
    String? lastName,
    String? country,
    String? countryCode,
    String? phoneNumber,
    String? account,
    String? ssnNumber,
    String? tinNumber,
    String? routingNumber,
    String? dob,
    String? file,
    AddressDataModel? addressDataModel,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data["bank_id"] = id;
    data["first_name"] = firstName;
    data["last_name"] = lastName;
    data["country"] = country;
    data["account_number"] = account;
    data["ssn_last4_number"] = ssnNumber;
    // data["tin_number"] = tinNumber;
    data["routing_number"] = routingNumber;
    data["date_of_birth"] = dob;
    data["address"] = addressDataModel;
    data["country_code"] = countryCode;
    data["phone"] = phoneNumber;
    data["file"] = file;

    return data;
  }

  static contactUsRequestModel({
    required String name,
    required String email,
    required String subject,
    required String description,
    required String country,
    required String phone,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["email"] = email.toLowerCase();
    data["subject"] = subject;
    data["message"] = description;
    data["country_code"] = country;
    data["phone"] = phone;
    return data;
  }

  static reportRequestModel({
    required String? type,
    required String? reason,
    required String? message,
    required dynamic id,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["type"] = type;
    data["reason"] = reason;
    data["report_for"] = id;
    data["message"] = message;
    return data;
  }

  static makeEarningPaymentRequest({
    required var amount,
    // required var paymentId,
    required var weekStart,
    required var weekEnd,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["amount"] = amount;
    // data["payment_method_id"] = paymentId?.toString();
    data["week_start"] = weekStart;
    data["week_end"] = weekEnd;
    return data;
  }

  static updateDriverStateRequest({
    required String? state,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = state;
    return data;
  }

  static updateDriverLocation({
    required var lat,
    required var long,
    var heading,
    var token,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["latitude"] = lat.toString();
    data["longitude"] = long.toString();
    if (heading != null) data["heading"] = heading.toString();
    if (token != null) data["token"] = token.toString();
    return data;
  }

  static changeStatusRequest({
    required var bookingId,
    required var status,
    String? otp,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["booking_id"] = bookingId;
    data["status"] = status;
    data["otp"] = otp;
    return data;
  }

  //  list query
  static paginationRequest({int page = 1, int perPage = pageItemsLimit}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["page"] = page;
    data["limit"] = perPage;
    return data;
  }

  //  list query
  static bookingsListRequest(
      {int page = 1, int perPage = pageItemsLimit, String? status}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["page"] = page;
    data["limit"] = perPage;
    return data;
  }

  static addReviewRequest(
      {num? rating, String? description, String? bookingId}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["booking_id"] = bookingId;
    data["rate"] = rating;
    data["description"] = description;
    return data;
  }

  static startride(
      {LatLongModel? pickupLocation,
      LatLongModel? dropLocation,
      String? pickupaddress,
      String? dropaddress}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pickupLocation != null) {
      data['pickup_location'] = pickupLocation!.toJson();
    }
    if (dropLocation != null) {
      data['drop_location'] = dropLocation!.toJson();
    }
    data["pickup_address"] = pickupaddress;
    data["drop_address"] = dropaddress;

    return data;
  }

  // class RideBooking {
  // PickupLocation? pickupLocation;
  // PickupLocation? dropLocation;
  //
  // RideBooking({this.pickupLocation, this.dropLocation});
  //
  // // Static method to create a map for ride booking request
  // static Map<String, dynamic> rideBookingRequestModel({
  // required PickupLocation? pickupLocation,
  // required PickupLocation? dropLocation,
  // }) {
  // final Map<String, dynamic> data = <String, dynamic>{};
  //
  // // Add pickupLocation and dropLocation to the map
  // if (pickupLocation != null) {
  // data['pickup_location'] = pickupLocation.toJson();
  // }
  // if (dropLocation != null) {
  // data['drop_location'] = dropLocation.toJson();
  // }
  //
  // return data;
  // }
  // }
}
