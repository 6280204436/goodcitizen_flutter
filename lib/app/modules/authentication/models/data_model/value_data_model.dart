class ValueDataModel {
  String? uniqueId;

  ValueDataModel({this.uniqueId});

  ValueDataModel.fromJson(Map<String, dynamic> json) {
    uniqueId = json['uniqueId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uniqueId'] = this.uniqueId;
    return data;
  }
}