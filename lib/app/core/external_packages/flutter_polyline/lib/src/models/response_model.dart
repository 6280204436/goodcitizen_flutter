class NewPolylineResponseModel {
  List<NewPolylineRouteModel>? routes;

  NewPolylineResponseModel({this.routes});

  NewPolylineResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['routes'] != null) {
      routes = <NewPolylineRouteModel>[];
      json['routes'].forEach((v) {
        routes!.add(new NewPolylineRouteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.routes != null) {
      data['routes'] = this.routes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewPolylineRouteModel {
  int? distanceMeters;
  String? duration;
  EncodedPolylineModel? polyline;

  NewPolylineRouteModel({this.distanceMeters, this.duration, this.polyline});

  NewPolylineRouteModel.fromJson(Map<String, dynamic> json) {
    distanceMeters = json['distanceMeters'];
    duration = json['duration'];
    polyline = json['polyline'] != null
        ? new EncodedPolylineModel.fromJson(json['polyline'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distanceMeters'] = this.distanceMeters;
    data['duration'] = this.duration;
    if (this.polyline != null) {
      data['polyline'] = this.polyline!.toJson();
    }
    return data;
  }
}

class EncodedPolylineModel {
  String? encodedPolyline;

  EncodedPolylineModel({this.encodedPolyline});

  EncodedPolylineModel.fromJson(Map<String, dynamic> json) {
    encodedPolyline = json['encodedPolyline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['encodedPolyline'] = this.encodedPolyline;
    return data;
  }
}
