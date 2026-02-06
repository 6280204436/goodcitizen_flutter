class StartRideResponse {
  String? message;
  Data? data;

  StartRideResponse({this.message, this.data});

  StartRideResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? driverId;
  PickupLocation? pickupLocation;
  PickupLocation? dropLocation;
  String? status;
  String? pickupAddress;
  String? dropAddress;
  String? createdAt;
  String? sId;

  Data(
      {this.driverId,
        this.pickupLocation,
        this.dropLocation,
        this.status,
        this.pickupAddress,
        this.dropAddress,
        this.createdAt,
        this.sId});

  Data.fromJson(Map<String, dynamic> json) {
    driverId = json['driver_id'];
    pickupLocation = json['pickup_location'] != null
        ? new PickupLocation.fromJson(json['pickup_location'])
        : null;
    dropLocation = json['drop_location'] != null
        ? new PickupLocation.fromJson(json['drop_location'])
        : null;
    status = json['status'];
    pickupAddress = json['pickup_address'];
    dropAddress = json['drop_address'];
    createdAt = json['created_at'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driver_id'] = this.driverId;
    if (this.pickupLocation != null) {
      data['pickup_location'] = this.pickupLocation!.toJson();
    }
    if (this.dropLocation != null) {
      data['drop_location'] = this.dropLocation!.toJson();
    }
    data['status'] = this.status;
    data['pickup_address'] = this.pickupAddress;
    data['drop_address'] = this.dropAddress;
    data['created_at'] = this.createdAt;
    data['_id'] = this.sId;
    return data;
  }
}

class PickupLocation {
  double? latitude;
  double? longitude;
  String? sId;

  PickupLocation({this.latitude, this.longitude, this.sId});

  PickupLocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['_id'] = this.sId;
    return data;
  }
}