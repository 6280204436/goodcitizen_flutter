import 'package:good_citizen/app/modules/profile/models/data_model/faq_model.dart';


class FaqListResponseModel {
  List<FaqDataModel>? data;
  int? count;

  FaqListResponseModel({this.data, this.count});

  FaqListResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <FaqDataModel>[];
      json['data'].forEach((v) {
        data!.add( FaqDataModel.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}


