import '../data_models/booking_data_model.dart';

class BookingResponseModel {
  BookingDataModel? data;

  BookingResponseModel({this.data});

  BookingResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new BookingDataModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}







