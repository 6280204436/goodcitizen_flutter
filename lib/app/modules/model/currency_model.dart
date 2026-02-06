class CurrencyModel {
  String? name;
  String? code;
  String? symbol;

  CurrencyModel({this.name, this.code, this.symbol});

  CurrencyModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    data['symbol'] = this.symbol;
    return data;
  }
}
