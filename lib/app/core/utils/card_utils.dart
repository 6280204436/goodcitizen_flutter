import 'package:get/get.dart';

import '../values/app_assets.dart';
import 'localizations/localizations.dart';

enum CardType {
  master,
  visa,
  verve,
  discover,
  americanExpress,
  dinersClub,
  jcb,
  others,
  invalid
}

class CardInfoData {
  CardType cardType;
  String? imagePath;

  CardInfoData({this.cardType = CardType.others, this.imagePath});
}

class CardUtils {
  static CardInfoData getCardTypeFrmNumber(String input) {
    CardInfoData cardType;
    if (input.startsWith(RegExp(
        r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
      cardType =
          CardInfoData(cardType: CardType.master, imagePath: icCardMaster);
    } else if (input.startsWith(RegExp(r'[4]'))) {
      cardType = CardInfoData(cardType: CardType.visa, imagePath: icCardVisa);
    } else if (input.startsWith(RegExp(r'((506(0|1))|(507(8|9))|(6500))'))) {
      cardType = CardInfoData(cardType: CardType.verve);
    } else if (input.startsWith(RegExp(r'((34)|(37))'))) {
      cardType = CardInfoData(
          cardType: CardType.americanExpress, imagePath: icCardAmerican);
    } else if (input.startsWith(RegExp(r'((6[45])|(6011))'))) {
      cardType =
          CardInfoData(cardType: CardType.discover, imagePath: icCardDiscover);
    } else if (input.startsWith(RegExp(r'((30[0-5])|(3[89])|(36)|(3095))'))) {
      cardType = CardInfoData(cardType: CardType.dinersClub);
    } else if (input.startsWith(RegExp(r'(352[89]|35[3-8][0-9])'))) {
      cardType = CardInfoData(cardType: CardType.jcb, imagePath: icCardJcb);
    } else if (input.length <= 8) {
      cardType = CardInfoData(cardType: CardType.others);
    } else {
      cardType = CardInfoData(cardType: CardType.invalid);
    }
    return cardType;
  }

  static String getCleanedNumber(String text) {
    RegExp regExp = RegExp(r"[^0-9]");
    return text.replaceAll(regExp, '');
  }

  static String? validateCardNum(String? input) {
    if (input == null || input.isEmpty) {
      return keyPlsEnterCardNumber.tr;
    }
    input = getCleanedNumber(input);
    if (input.length < 8) {
      return keyCardInvalid.tr;
    }
    int sum = 0;
    int length = input.length;
    for (var i = 0; i < length; i++) {
// get digits in reverse order
      int digit =
      int.parse(input[length - i - 1]); // every 2nd number multiply with 2
      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }
    if (sum % 10 == 0) {
      return null;
    }
    return keyCardInvalid.tr;
  }

  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return keyPlsEnterCVV.tr;
    }
    if (value.length < 3 || value.length > 4) {
      return keyCVVInvalid.tr;
    }
    return null;
  }

  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return keyPlsEnterCardExpiry.tr;
    }
    int year;
    int month;
    if (value.contains(RegExp(r'(/)'))) {
      var split = value.split(RegExp(r'(/)'));

      month = int.parse(split[0]);
      year = int.parse(split[1]);
    } else {
      month = int.parse(value.substring(0, (value.length)));
      year = -1; // Lets use an invalid year intentionally
    }
    if ((month < 1) || (month > 12)) {
      // A valid month is between 1 (January) and 12 (December)
      return keyMonthInvalid.tr;
    }
    var fourDigitsYear = convertYearTo4Digits(year);
    if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
      // We are assuming a valid should be between 1 and 2099.
      // Note that, it's valid doesn't mean that it has not expired.
      return keyYearInvalid.tr;
    }
    if (!hasDateExpired(month, year)) {
      return keyCardExpired.tr;
    }
    return null;
  }

  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  static bool hasDateExpired(int month, int year) {
    return isNotExpired(year, month);
  }

  static bool isNotExpired(int year, int month) {
    // It has not expired if both the year and date has not passed
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  static List<int> getExpiryDate(String value) {
    var split = value.split(RegExp(r'(/)'));
    return [int.parse(split[0]), int.parse(split[1])];
  }

  static bool hasMonthPassed(int year, int month) {
    var now = DateTime.now();
    // The month has passed if:
    // 1. The year is in the past. In that case, we just assume that the month
    // has passed
    // 2. Card's month (plus another month) is more than current month.
    return hasYearPassed(year) ||
        convertYearTo4Digits(year) == now.year && (month < now.month);
  }

  static bool hasYearPassed(int year) {
    int fourDigitsYear = convertYearTo4Digits(year);
    var now = DateTime.now();
    // The year has passed if the year we are currently is more than card's
    // year
    return fourDigitsYear < now.year;
  }
}
