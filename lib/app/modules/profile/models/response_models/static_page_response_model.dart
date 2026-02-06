import '../data_model/static_page_model.dart';

class StaticPageResponseModel {
  StaticPageDataModel? data;

  StaticPageResponseModel({this.data});

  StaticPageResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new StaticPageDataModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}


