class StaticModel {

  List<Data>? data;

  StaticModel({ this.data});

  StaticModel.fromJson(Map<String, dynamic> json) {

    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? type;
  String? image;
  String? title;
  String? content;
  String? createdAt;

  Data({this.sId, this.type, this.image, this.title, this.content, this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    image = json['image'];
    title = json['title'];
    content = json['content'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['type'] = this.type;
    data['image'] = this.image;
    data['title'] = this.title;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    return data;
  }
}