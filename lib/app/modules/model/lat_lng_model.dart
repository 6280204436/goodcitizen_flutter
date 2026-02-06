class LatLongModel {
  var id;
  var lat;
  var long;

  LatLongModel({
    this.lat,
    this.long,
  });

  LatLongModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.lat;
    data['longitude'] = this.long;

    return data;
  }
}
