class NotificationResponse {
  int? count;
  List<Notification>? notification;

  NotificationResponse({this.count, this.notification});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['notification'] != null) {
      notification = <Notification>[];
      json['notification'].forEach((v) {
        notification!.add(new Notification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.notification != null) {
      data['notification'] = this.notification!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notification {
  String? sId;
  String? userId;
  DriverId? driverId;
  String? message;
  String? ambulanceNum;
  String? distance;
  String? status;
  String? createdAt;
  num? iV;

  Notification(
      {this.sId,
        this.userId,
        this.driverId,
        this.message,
        this.ambulanceNum,
        this.distance,
        this.status,
        this.createdAt,
        this.iV});

  Notification.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    driverId = json['driver_id'] != null
        ? new DriverId.fromJson(json['driver_id'])
        : null;
    message = json['message'];
    ambulanceNum = json['ambulance_num'];
    distance = json['distance'];
    status = json['status'];
    createdAt = json['created_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    if (this.driverId != null) {
      data['driver_id'] = this.driverId!.toJson();
    }
    data['message'] = this.message;
    data['ambulance_num'] = this.ambulanceNum;
    data['distance'] = this.distance;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class DriverId {
  String? sId;
  String? firstName;
  String? lastName;
  String? email;

  DriverId({this.sId, this.firstName, this.lastName, this.email});

  DriverId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    return data;
  }
}