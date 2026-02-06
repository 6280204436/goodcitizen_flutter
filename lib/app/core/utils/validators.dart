import 'package:good_citizen/app/core/utils/common_item_model.dart';

import '../../export.dart';

class EmailValidator {
  static validateEmail({String? value, String? title}) {
    if (value == null || value.isEmpty) {
      return keyPlsEnterYourEmail.tr;
    } else if (!GetUtils.isEmail(value.trim())) {
      return keyInvalidEmail.tr;
    }
    return null;
  }
}


class NameValidator {
  static String? validateName({required String title, required String value}) {
    if (value.isEmpty) {
      return '$title cannot be empty';
    }
    if (value.length < 2) {
      return '$title must be at least 2 characters long';
    }
    if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(value)) {
      return '$title can only contain letters';
    }
    return null;
  }
}
/*================================================== Password Validator ===================================================*/

class PasswordFormValidator {
  static validatePassword({String? value, String? title}) {
    var pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return "${keyPlsEnterYour.tr.toLowerCase()} ${title?.tr.toLowerCase()}";
    } else if (!regExp.hasMatch(value)) {
      return keyInsecurePassword.tr;
    }
    return null;
  }

  static validateConfirmPasswordMatch(
      {String? value, String? password, String? title}) {
    if (value!.isEmpty) {
      return '$title ${keyCantEmpty.tr.toLowerCase()}';
    } else if (value != password) {
      return keyPassNotMatched.tr;
    }
    return null;
  }
}

/*================================================== Phone Number Validator ===================================================*/

class PhoneNumberValidate {
//   static validateMobile(String value) {
//     if (value.isEmpty) {
//       return strPhoneEmEmpty;
//     } else if (value.length < 8 || value.length > 15) {
//       return strPhoneNumberInvalid;
//     } else if (!validateNumber(value)) {
//       return strSpecialCharacter;
//     }
//     return null;
//   }
// }

  bool validateNumber(String value) {
    var pattern = r'^[0-9]+$';
    RegExp regex = RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }
}

/*===============================Field Checker=================================================*/
class FieldChecker {
  static fieldChecker({String? value, String? title, String? completeMessage}) {
    if (value == null || value.toString().trim().isEmpty) {
      return completeMessage?.tr ??
          "${keyPlsEnterYour.tr.toLowerCase()} ${title?.tr.toLowerCase()}".capitalizeFirst;
    }
    return null;
  }

  static minLengthValidator({String? value, String? title, String? completeMessage,int? length}) {
    if (value == null || value.toString().trim().isEmpty) {
      return completeMessage?.tr ??
          "${keyPlsEnterYour.tr.toLowerCase()} ${title?.tr.toLowerCase()}".capitalizeFirst;
    }

    if(length!=null &&  value.length<length)
      {
        return
            "${keyMinimum.tr.toLowerCase()} $length ${keyCharRequired?.tr.toLowerCase()}".capitalizeFirst;
      }
    return null;
  }

  static String? otpValidator({String? value}) {
    if (value == null || value.toString().trim().isEmpty) {
      return keyPlsEnterOtp.tr;
    } else if (value.length < 4) {
      return keyInvalidOtp.tr;
    } else {
      return null;
    }
  }

  static dropDownValidator(
      {CommonItemModel? value, String? title, String? completeMessage}) {
    if (value == null) {
      return completeMessage?.tr ??
          "${keyPlsEnterYour.tr.toLowerCase()} ${title?.tr.toLowerCase()}";
    }
    return null;
  }

  static maxValueValidator(
      {String? value,
      String? title,
      String? completeMessage,
      int maxValue = 30}) {
    if (value == null || value.toString().trim().isEmpty) {
      return completeMessage?.tr ??
          "${keyPlsEnterYour.tr.toLowerCase()} ${title?.tr.toLowerCase()}";
    } else if (num.parse(value.toString()) < 1) {
      return keyInvalidValue.tr;
    } else if (num.parse(value.toString()) > (maxValue)) {
      return 
          "${keyMaximum.tr} $maxValue ${keyAllowed.tr.toLowerCase()}";
    }
    return null;
  }

  static greaterZeroValidator(
      {String? value,
      String? title,
      String? completeMessage,
      String? limit,
      String? limitTitle,
      String? minLimit}) {
    if (value == null || value.toString().trim().isEmpty) {
      return completeMessage?.tr ??
          "${keyPlsEnterYour.tr.toLowerCase()} ${title?.tr.toLowerCase()}";
    } else if (num.parse((value ?? 0).toString()) <= 0) {
      return  "$title ${keyMustBeGreater.tr} 0";
    } else if (minLimit != null &&
        num.parse((value ?? 0).toString()) < num.parse(minLimit)) {
      return  "$title ${keyCantBeLess.tr} $limitTitle";
    } else if (limit != null &&
        num.parse((value ?? 0).toString()) > num.parse(limit)) {
      return  "$title ${keyCantBeGreater.tr} $limitTitle";
    }
    return null;
  }

  static fourDigitPinValidator({String? value, String? title}) {
    if (value == null || value.toString().trim().isEmpty) {
      return "${keyPlsEnterYour.tr.toLowerCase()} ${title?.toUpperCase()}";
    } else if (value.length < 4) {
      return keyInvalidOtp.tr;
    } else {
      return null;
    }
  }

  static lengthValidator(
      {String? value, String? title, String? completeMessage, int? length}) {
    if (value == null || value.toString().trim().isEmpty) {
      return completeMessage?.tr ??
          "${keyPlsEnterYour.tr.toLowerCase()} ${title?.tr.toLowerCase()}";
    } else if (length != null && value.length != length) {
      return '${title?.tr.capitalizeFirst} ${keyMustContain.tr.toLowerCase()} $length ${keyDigits.tr.toLowerCase()}';
    }
    return null;
  }

  static routingValidator(
      {String? value, String? title, String? completeMessage, int? length}) {
    if (value == null || value.toString().trim().isEmpty) {
      return completeMessage?.tr ??
          "${keyPlsEnterYour.tr.toLowerCase()} ${title?.tr.toLowerCase()}";
    } else if (length != null && value.length < length) {
      return '${title?.tr.capitalizeFirst} ${keyMustContain.tr.toLowerCase()} ${keyAtLeast.tr.toLowerCase()} $length ${keyDigits.tr.toLowerCase()}';
    }
    return null;
  }
}
