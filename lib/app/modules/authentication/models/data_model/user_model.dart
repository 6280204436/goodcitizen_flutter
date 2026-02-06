import 'package:good_citizen/app/modules/home_module/models/data_models/booking_data_model.dart';
import 'package:good_citizen/app/modules/profile/models/address_data_model.dart';

class UserDataModel {
  String? sId;
  String? userType;
  String? name;
  String? email;
  String? tempEmail;
  String? password;
  String? countryCode;
  String? phone;
  String? gender;
  String? genderType;
  String? bio;
  String? dateOfBirth;
  String? image;
  AddressDataModelOld? address;
  String? location;
  String? tempCountryCode;
  String? tempPhone;
  int? emailOtp;
  int? phoneOtp;
  String? language;
  String? reasonOfDeactivate;
  String? descriptionOfDeactivate;
  bool? isActive;
  bool? isBlock;
  bool? isEmailVerify = false;
  bool? isPhoneVerify = false;
  bool? isVerifiedUser;
  bool? isHost;
  bool? isBankAdded;
  int? createdAt;
  String? avgResponseTime;
  String? responseRate;
  String? message;

  bool? isTrial;

  String? profilePic;
  String? coverImg;
  String? vehicleTypeId;

  bool? isDocUpdated;
  int? licExpiryDate;
  int? rejectOn;
  String? docExpiryType;

  BookingDataModel? currentBooking;

  // String? phoneNo;

  var custumerId;

  var updatedAt;
  bool? isDeleted;

  bool? isBlocked;
  bool? isIndividual;
  var iV;
  String? accessToken;

  String? description;
  String? subTitle;
  String? type;

  var rating;
  var noOfReview;

  String? requestId;

  var walletBalance;

  String? prefLanguage;
  String? prefCurrency;
  String? currencySymbol='\$';

  String? loginType;

  double? latitude;
  double? longitude;
  double? heading;

  int? tempEmailOtp;

  bool? isApproved;
  num? approvedOn;
  String? status;
  String? rideStatus;
  String? deviceType;
  String? preferredLanguage;
  String? preferredCurrency;
  String? customerId;
  num? ratings;
  var socketId;
  bool? setUpProfile;
  bool? setUpVehicle;
  bool? setUpDocuments;

  String? licFront;
  String? licBack;

  UserDataModel(
      {this.sId,
      this.name,
      this.email,
      this.profilePic,
      this.coverImg,
      this.gender,
      // this.phoneNo,
      this.countryCode,
      this.tempCountryCode,
      this.userType,
      this.custumerId,
      this.createdAt,
      this.updatedAt,
      this.isDeleted,
      this.isEmailVerify,
      this.isPhoneVerify,
      this.isActive,
      this.isBlocked,
      this.iV,
      this.accessToken,
      this.isIndividual,
      this.subTitle,
      this.type,
      this.description,
      this.tempEmail,
      this.phone,
      this.image,
      this.address,
      this.location,
      this.tempPhone,
      this.isVerifiedUser,
      this.isBankAdded});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    countryCode = json['country_code'];
    prefLanguage = json['preferred_language'];
    prefCurrency = json['preferred_currency'];
    phone = json['phone'];
    image = json['image'];
    isBankAdded = json['is_bank_added'];
    latitude = json['latitude'] is String
        ?json['latitude']=="null"?null: double.parse(json['latitude'])
        : json['latitude'];
    longitude = json['longitude'] is String
        ?json['longitude']=="null"?null:  double.parse(json['longitude'])
        : json['longitude'];
    heading = json['heading'] is String ? double.parse(json['heading']) : json['heading'];
    tempEmail = json['temp_email'];
    tempPhone = json['temp_phone'];
    tempCountryCode = json['temp_country_code'];
    tempEmailOtp = json['temp_email_otp'];
    isActive = json['is_active'];
    isBlock = json['is_block'];
    isApproved = json['is_approved'];
    approvedOn = json['approved_on'];
    isEmailVerify = json['is_email_verify'];
    isPhoneVerify = json['is_phone_verify'];
    status = json['status'];
    rideStatus = json['ride_status'];
    deviceType = json['device_type'];
    preferredLanguage = json['preferred_language'];
    preferredCurrency = json['preferred_currency'];
    currencySymbol = json['currency_symbol']??'\$';
    customerId = json['customer_id'];
    ratings = json['ratings'];
    socketId = json['socket_id'];
    setUpProfile = json['set_up_profile'];
    setUpVehicle = json['set_up_vehicle'];
    setUpDocuments = json['set_up_documents'];
    licBack = json['licence_back_image'];
    licFront = json['licence_front_image'];
    isDocUpdated = json['is_doc_update'];
    isDeleted = json['is_deleted'];
    vehicleTypeId = json['vehicle_type_id'];
    licExpiryDate = json['licence_expiry_date'];
    docExpiryType = json['doc_expiry_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    rejectOn = json['reject_on'];
    iV = json['__v'];
    currentBooking = json['current_booking'] != null
        ? json['current_booking'] is String
            ? BookingDataModel(sId: json['current_booking'])
            : BookingDataModel.fromJson(json['current_booking'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['temp_email'] = this.tempEmail;
    data['temp_phone'] = this.tempPhone;
    data['temp_country_code'] = this.tempCountryCode;
    data['temp_email_otp'] = this.tempEmailOtp;
    data['preferred_language'] = this.prefLanguage;
    data['preferred_currency'] = this.prefCurrency;
    data['currency_symbol'] = this.currencySymbol;
    data['is_active'] = this.isActive;
    data['is_block'] = this.isBlock;
    data['is_bank_added'] = this.isBankAdded;
    data['is_approved'] = this.isApproved;
    data['approved_on'] = this.approvedOn;
    data['is_email_verify'] = this.isEmailVerify;
    data['is_phone_verify'] = this.isPhoneVerify;
    data['status'] = this.status;
    data['ride_status'] = this.rideStatus;
    data['device_type'] = this.deviceType;
    data['preferred_language'] = this.preferredLanguage;
    data['preferred_currency'] = this.preferredCurrency;
    data['customer_id'] = this.customerId;
    data['ratings'] = this.ratings;
    data['socket_id'] = this.socketId;
    data['set_up_profile'] = this.setUpProfile;
    data['set_up_vehicle'] = this.setUpVehicle;
    data['is_doc_update'] = this.isDocUpdated;
    data['set_up_documents'] = this.setUpDocuments;
    data['licence_back_image'] = this.licBack;
    data['licence_front_image'] = this.licFront;
    data['vehicle_type_id'] = this.vehicleTypeId;
    data['is_deleted'] = this.isDeleted;
    data['licence_expiry_date'] = this.licExpiryDate;
    data['doc_expiry_type'] = this.docExpiryType;
    data['created_at'] = this.createdAt;
    data['reject_on'] = this.rejectOn;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
