

import '../data_models/booking_data_model.dart';

class BookingsListResponseModel {
  int? count;
  List<BookingDataModel>? data;

  BookingsListResponseModel({this.count, this.data});

  BookingsListResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = <BookingDataModel>[];
      json['data'].forEach((v) {
        data!.add(new BookingDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


