class UserResponseModel {
  Data? data;

  UserResponseModel({this.data});

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? message;
  String? sId;
  String? email;
  String? firstname;
  String? lastname;
  String? gender;
  String? countrycode;
  String?  profile_pic;
  String? phonenumber;
  String? approval;
  String? aadharFront;
  String? aadharBack;
  String? dlFront;
  String? dlBack;
  String? dlExpireDate;
  String? ambulanceNum;
  String? hospitalDoc;
  String? accessToken;
  dynamic loyaltypoint;
  dynamic distance;
  String? role;
  bool? isEmailVerified;
  String? rideid;
  String? dl_num;
  Data(
      {this.message,
        this.sId,
        this.email,
        this.approval,
        this.aadharFront,
        this.aadharBack,
        this.dlFront,
        this.dl_num,
        this.dlExpireDate,
        this.dlBack,
        this.hospitalDoc,
        this.ambulanceNum,
        this.accessToken,
        this.role,
        this.gender,
        this.countrycode,
        this.firstname,
        this.profile_pic,
        this.lastname,
        this.phonenumber,
        this.loyaltypoint,
        this.distance,
        this.rideid,
        this.isEmailVerified});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    sId = json['_id'];
    email = json['email'];
    dl_num = json['dl_num'];
    accessToken = json['access_token'];
    approval = json['approval'];
    aadharFront = json['aadhar_front'];
    aadharBack = json['aadhar_back'];
    dlExpireDate = json['dl_expire_date'];
    dlFront = json['dl_front'];
    dlBack = json['dl_back'];
    hospitalDoc= json['hospital_doc'];
    ambulanceNum= json['ambulance_num'];
    profile_pic = json['profile_pic'];
    role = json['role'];
    gender = json['gender'];
    loyaltypoint=json["loyalty_point"];
    rideid = json['ride_id'];
    firstname = json['first_name'];
    lastname = json['last_name'];
    countrycode=json["country_code"];
    distance=json["distance"];
    phonenumber = json['phone_number'];
    isEmailVerified = json['is_email_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['_id'] = this.sId;
    data['dl_num'] = this.dl_num;
    data['email'] = this.email;
    data['access_token'] = this.accessToken;
    data['loyalty_point']=this.loyaltypoint;
    data['profile_pic']=this.profile_pic;
    data['role'] = this.role;
    data['approval'] = this.approval;
    data['aadhar_front'] = this.aadharFront;
    data['aadhar_back'] = this.aadharBack;
    data['dl_expire_date'] = this.dlExpireDate;
    data['dl_front'] = this.dlFront;
    data['dl_back'] = this.dlBack;

    data['hospital_doc'] = this.hospitalDoc;
    data['ambulance_num'] = this.ambulanceNum;



    data['gender'] = this.gender;
    data['first_name'] = this.firstname;
    data['last_name']=this.lastname;
    data["country_code"]=this.countrycode;
    data["distance"]=this.distance;
    data['phone_number']=this.phonenumber;
    data['ride_id'] = this.rideid;
    data['is_email_verified'] = this.isEmailVerified;
    return data;
  }
}