import 'package:good_citizen/app/export.dart';

class AddressDataModelOld {
  var id;
  int? userId;
  var lat;
  var long;
  String? address;
  String? tags;
  var createdAt;
  var updatedAt;

  String? country;
  String? street;
  String? flatSuite;
  String? city;
  String? state;
  String? postCode;

  List<double>? coordinates;
  String? locationName;
  String? type;

  AddressDataModelOld(
      {this.id,
      this.userId,
      this.lat,
      this.long,
      this.address,
      this.tags,
      this.country,
      this.postCode,
      this.state,
      this.city,
      this.flatSuite,
      this.street,
      this.locationName,
      this.type,
      this.coordinates,
      this.createdAt,
      this.updatedAt});

  AddressDataModelOld.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    lat = json['lat'];

    long = json['long'];
    address = json['address'];
    tags = json['tags'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    country = json['country'];
    street = json['street'];
    flatSuite = json['flat_suite'];
    city = json['city'];
    state = json['state'];
    postCode = json['post_code'];
    type = json['type'];
    locationName = json['name'];
    coordinates = (json['coordinates'] != null && json['coordinates'] != [])
        ? json['coordinates'].cast<double>()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    // data['user_id'] = this.userId;
    // data['lat'] = this.lat;
    // data['long'] = this.long;
    // data['address'] = this.address;
    // data['tags'] = this.tags;
    // data['created_at'] = this.createdAt;
    // data['updated_at'] = this.updatedAt;

    if (country != null) data['country'] = this.country;
    if (street != null) data['street'] = this.street;
    if (flatSuite != null) data['flat_suite'] = this.flatSuite;
    if (city != null) data['city'] = this.city;
    if (state != null) data['state'] = this.state;
    if (postCode != null) data['post_code'] = this.postCode;
    if (locationName != null) data['name'] = this.locationName;
    if (type != null) data['type'] = this.type;
    if (coordinates != null) data['coordinates'] = this.coordinates;

    return data;
  }
}

class AddressDataModel {
  dynamic id;
  int? userId;
  double? lat;
  double? long;

  dynamic createdAt;
  dynamic updatedAt;

  String? country;
  String? street;
  String? flatSuite;
  String? city;
  String? state;
  String? postCode;
  String? line1;

  ///fields for input
  TextEditingController fieldController = TextEditingController();
  FocusNode fieldNode = FocusNode();

  String? fieldTitle;
  String? filedHint;

  Widget? stepperPrefix; //to show in stepper
  Widget? stepperSuffix; //to show in stepper

  bool isAStop = false;
  String? formattedAddress;

  double? _heading;

  void setHeading(double? value) {
    if (value == null) {
      return;
    }
    if (_heading == null) {
      _heading = value;
    } else if ((value - _heading!).abs() >= 45) {
      _heading = value;
    } else if (_heading?.abs() != 0 &&
        (_heading?.abs() ?? 0) < 270 &&
        value == 0) {
      return;
    } else {
      _heading = value;
    }
  }

  double get getHeading {
    return _heading ?? 0;
  }

  AddressDataModel(
      {this.id,
      this.userId,
      this.lat,
      this.long,
      this.country,
      this.line1,
      this.postCode,
      this.state,
      this.city,
      this.flatSuite,
      this.street,
      this.fieldTitle,
      this.filedHint,
      this.stepperPrefix,
      this.stepperSuffix,
      this.isAStop = false,
      this.createdAt,
      this.updatedAt});

  AddressDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    lat = json['lat'] is String ? double.parse(json['lat']) : json['lat'];
    long = json['long'] is String ? double.parse(json['long']) : json['long'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    country = json['country'];
    street = json['street'];
    line1 = json['line1'];
    flatSuite = json['flat_suite'];
    city = json['city'];
    _heading = json['heading'];
    formattedAddress = json['name'] ?? json['address'];
    state = json['state'];
    postCode = json['post_code'] ?? json['postal_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (country != null) data['country'] = this.country;
    if (street != null) data['street'] = this.street;
    if (line1 != null) data['line1'] = this.line1;
    if (flatSuite != null) data['flat_suite'] = this.flatSuite;
    if (city != null) data['city'] = this.city;
    if (state != null) data['state'] = this.state;
    if (postCode != null) data['postal_code'] = this.postCode;
    if (_heading != null) data['heading'] = this._heading;

    return data;
  }
}
