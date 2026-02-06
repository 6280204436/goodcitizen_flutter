class FaqDataModel {
  String? sId;
  String? questions;
  String? answer;
  bool? isDeleted;
  int? createdAt;
  int? updatedAt;
  int? iV;

  FaqDataModel(
      {this.sId,
        this.questions,
        this.answer,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.iV});

  FaqDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    questions = json['question'];
    answer = json['answer'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['questions'] = this.questions;
    data['answer'] = this.answer;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}