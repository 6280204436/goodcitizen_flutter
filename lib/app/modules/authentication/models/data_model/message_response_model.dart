import 'package:good_citizen/app/modules/authentication/models/data_model/value_data_model.dart';

class MessageResponseModel {
  int? statusCode;
  String? message;
  String? errorCode;
  String? uniqueId;
  ValueDataModel? data;
  String?access_token;

  MessageResponseModel({this.statusCode, this.message,this.errorCode,this.access_token,this.uniqueId});

  MessageResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    uniqueId = json['uniqueId'];
    access_token = json['access_token'];

    data = json['data'] != null ?  ValueDataModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['access_token'] = this.access_token;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
