import 'package:good_citizen/app/core/utils/common_item_model.dart';

import 'modules/model/currency_model.dart';

final List<Map<String, dynamic>> _currenciesJson = [
  {"name": "United States Dollar", "code": "USD", "symbol": "\$"},
  // {"name": "Euro", "code": "EUR", "symbol": "€"},
  // {"name": "British Pound Sterling", "code": "GBP", "symbol": "£"},
  // {"name": "Japanese Yen", "code": "JPY", "symbol": "¥"},
  // {"name": "Swiss Franc", "code": "CHF", "symbol": "CHF"},
  // {"name": "Canadian Dollar", "code": "CAD", "symbol": "\$"},
  // {"name": "Australian Dollar", "code": "AUD", "symbol": "\$"},
  // {"name": "Chinese Yuan", "code": "CNY", "symbol": "¥"},
  {"name": "Indian Rupee", "code": "INR", "symbol": "₹"},
  // {"name": "Brazilian Real", "code": "BRL", "symbol": "R\$"},
  // {"name": "Russian Ruble", "code": "RUB", "symbol": "₽"},
  // {"name": "South Korean Won", "code": "KRW", "symbol": "₩"},
  // {"name": "Mexican Peso", "code": "MXN", "symbol": "\$"},
  // {"name": "South African Rand", "code": "ZAR", "symbol": "R"},
  // {"name": "New Zealand Dollar", "code": "NZD", "symbol": "\$"},
  // {"name": "Turkish Lira", "code": "TRY", "symbol": "₺"},
  // {"name": "Swedish Krona", "code": "SEK", "symbol": "kr"},
  // {"name": "Norwegian Krone", "code": "NOK", "symbol": "kr"},
  // {"name": "Singapore Dollar", "code": "SGD", "symbol": "\$"},
  // {"name": "Hong Kong Dollar", "code": "HKD", "symbol": "HK\$"},
  // {"name": "Danish Krone", "code": "DKK", "symbol": "kr"},
  // {"name": "Polish Zloty", "code": "PLN", "symbol": "zł"},
  // {"name": "Thai Baht", "code": "THB", "symbol": "฿"},
  // {"name": "Indonesian Rupiah", "code": "IDR", "symbol": "Rp"},
  // {"name": "Malaysian Ringgit", "code": "MYR", "symbol": "RM"}
];

List<CurrencyModel> _currenciesList = List.generate(_currenciesJson.length,
    (index) => CurrencyModel.fromJson(_currenciesJson[index]));

List<CommonItemModel> currenciesList = List.generate(
    _currenciesList.length,
    (index) => CommonItemModel(
        title:
            '${_currenciesList[index].code} (${_currenciesList[index].symbol})',

        id: _currenciesList[index].code));

CommonItemModel? getSelectedCurrency(var code) {
  final index = currenciesList.indexWhere((element) => element.id.toString().toLowerCase() == code.toString().toLowerCase());
  if (index != -1) {
    return currenciesList[index];
  }
  return null;
}