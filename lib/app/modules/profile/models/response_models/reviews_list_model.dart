
import '../data_model/rating_model.dart';

class ReviewsListResponseModel {
  int? count;
  String? overallRating;
  List<RatingModel>? data;

  ReviewsListResponseModel({this.count, this.overallRating, this.data});

  ReviewsListResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    overallRating = json['overall_rating'];
    if (json['data'] != null) {
      data = <RatingModel>[];
      json['data'].forEach((v) {
        data!.add(new RatingModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['overall_rating'] = this.overallRating;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


