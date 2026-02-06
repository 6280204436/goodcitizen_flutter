class ResendOtpResponse {
  OtpResponseData? data;

  ResendOtpResponse({this.data});

  ResendOtpResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new OtpResponseData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class OtpResponseData {
  String? message;
  String? accessToken;

  OtpResponseData({this.message, this.accessToken});

  OtpResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['access_token'] = this.accessToken;
    return data;
  }
}