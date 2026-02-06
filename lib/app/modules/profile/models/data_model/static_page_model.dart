class StaticPageDataModel {
  String? sId;
  String? title;
  String? description;
  String? url;
  String? image;
  int? createdAt;

  StaticPageDataModel(
      {this.sId,
        this.title,
        this.description,
        this.url,
        this.image,
        this.createdAt});

  StaticPageDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    image = json['image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    return data;
  }
}
