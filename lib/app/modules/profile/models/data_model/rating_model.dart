
import '../../../authentication/models/data_model/user_model.dart';

class RatingModel {
  String? sId;
  String? bookingId;
  UserDataModel? customer;
  UserDataModel? driver;
  num? rate;
  String? description;
  String? type;
  int? createdAt;
  int? updatedAt;
  int? iV;

  RatingModel(
      {this.sId,
        this.bookingId,
        this.rate,
        this.description,
        this.type,
        this.createdAt,
        this.updatedAt,
        this.iV});

  RatingModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    bookingId = json['booking_id'];
    customer = json['customer_id'] != null
        ? (json['customer_id'].runtimeType == String
        ? UserDataModel(sId: json['customer_id'])
        : UserDataModel.fromJson(json['customer_id']))
        : null;
    driver = json['driver_id'] != null
        ? (json['driver_id'].runtimeType == String
        ? UserDataModel(sId: json['driver_id'])
        : UserDataModel.fromJson(json['driver_id']))
        : null;
    rate = json['rate'];
    description = json['description'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['booking_id'] = this.bookingId;

    data['rate'] = this.rate;
    data['description'] = this.description;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}