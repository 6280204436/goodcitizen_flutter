class MediaUploadResponseModel {
  String? baseUrl;
  String? type;
  List<String>? folders;
  String? file_name ;

  MediaUploadResponseModel(
      {this.baseUrl, this.type, this.folders, this.file_name});

  MediaUploadResponseModel.fromJson(Map<String, dynamic> json) {
    baseUrl = json['base_url'];
    type = json['type'];
    file_name = json['file_name'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base_url'] = this.baseUrl;
    data['type'] = this.type;
    data['folders'] = this.folders;
    data['file_name'] = this.file_name;
    return data;
  }
}