

import 'package:flutter/cupertino.dart';

class Validator {
  static bool isRequired(String? value, {bool allowEmptySpaces = false}) {
    if (value == null || value.isEmpty) {
      return false;
    } else {
      if (!allowEmptySpaces) {
        // Check if the string is not only made of empty spaces
        if (RegExp(r"\s").hasMatch(value)) {
          return false;
        }
      }
      return true; // passed
    }
  }

  static bool isEmail(String? email) {
    if (!isRequired(email)) return false;

    // final emailRegex = RegExp(
    // r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    // RegExp(r'(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])');

    final emailRegex = RegExp(
        r"^((([a-zA-Z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-zA-Z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-zA-Z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-zA-Z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-zA-Z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-zA-Z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-zA-Z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-zA-Z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-zA-Z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");
    if (emailRegex.hasMatch(email!))
      return true;
    else
      return false;
  }

  /// Todo: Implement reason for failure
  /// For Validated passwords strings
  static bool isPassword(
      String? password, {
        int minLength = 4,
        int? maxLength,
        bool shouldContainNumber = false,
        bool shouldContainSpecialChars = false,
        bool shouldContainCapitalLetter = false,
        bool shouldContainSmallLetter = false,
        Function? reason,
        void Function(bool)? isNumberPresent,
        void Function(bool)? isSpecialCharsPresent,
        void Function(bool)? isCapitalLetterPresent,
        void Function(bool)? isSmallLetterPresent,
        void Function()? isMaxLengthFailed,
        void Function()? isMinLengthFailed,
      }) {
    if (password == null) {
      return false;
    }
    if (password.trim().length == 0) {
      return false;
    }

    if (password.length < minLength) {
      if (isMinLengthFailed != null) isMinLengthFailed();
      return false;
    }

    if (maxLength != null) {
      if (password.length > maxLength) {
        if (isMaxLengthFailed != null) isMaxLengthFailed();
        return false;
      }
    }

    if (shouldContainNumber) {
      final numberRegex = RegExp(r"[0-9]+");
      if (!numberRegex.hasMatch(password)) {
        if (isNumberPresent != null) isNumberPresent(false);
        return false;
      } else if (isNumberPresent != null) isNumberPresent(true);
    }

    if (shouldContainCapitalLetter) {
      final capitalRegex = RegExp(r"[A-Z]+");
      if (!capitalRegex.hasMatch(password)) {
        if (isCapitalLetterPresent != null) isCapitalLetterPresent(false);
        return false;
      } else if (isCapitalLetterPresent != null) isCapitalLetterPresent(true);
    }

    if (shouldContainSmallLetter) {
      final smallLetterRegex = RegExp(r"[a-z]+");
      if (!smallLetterRegex.hasMatch(password)) {
        if (isSmallLetterPresent != null) isSmallLetterPresent(false);
        return false;
      } else if (isSmallLetterPresent != null) isSmallLetterPresent(true);
    }

    if (shouldContainSpecialChars) {
//      final numberRegex = RegExp(r'(?=.*?[#?!@$%^&*-])');
      final specialRegex = RegExp(r"[\'^£$%!&*()}{@#~?><>,.|=_+¬-]");
      if (!specialRegex.hasMatch(password)) {
        if (isSpecialCharsPresent != null) isSpecialCharsPresent(false);
        return false;
      } else if (isSpecialCharsPresent != null) isSpecialCharsPresent(true);
    }

    return true;
  }

  static bool isEqualTo(dynamic value, dynamic valueToCompare) {
    if (value == valueToCompare) {
      return true;
    } else {
      return false;
    }
  }

  static bool isNotEqualTo(dynamic value, dynamic valueToCompare) {
    if (value == valueToCompare) {
      return false;
    } else {
      return true;
    }
  }


  static bool minLength(String value, int minLength) {
    if (value.isEmpty) return false;
    if (value.length >= minLength)
      return true;
    else
      return false;
  }

  static isNumber(String? value, {bool allowSymbols = false}) {
    if (value == null) return false;

    var numericRegEx = RegExp(r"^[+-]?([0-9]*[.])?[0-9]+$");
    var numericNoSymbolsRegExp = RegExp(r"^[0-9]+$");

    if (allowSymbols) {
      return numericRegEx.hasMatch(value);
    } else
      return numericNoSymbolsRegExp.hasMatch(value);
  }

  static bool length(String value, int length) {
    if (value.isEmpty) return false;
    if (value.length == length)
      return true;
    else
      return false;
  }


}

class FieldValidator {

  static FormFieldValidator<String> required({String? message}) {
    return (fieldValue) {
      if (Validator.isRequired(fieldValue)) {
        return null;
      } else {
        return message ?? "This Field is Required";
      }
    };
  }

  static FormFieldValidator<String> email({String? message}) {
    return (fieldValue) {
      if (Validator.isEmail(fieldValue)) {
        return null;
      } else {
        if (fieldValue != null && fieldValue.contains(" ")) {
          return "Space is present, email is not correct";
        }
        return message ?? "Email is not correct";
      }
    };
  }

  static FormFieldValidator<String> password({
    String? errorMessage,
    int minLength = 6,
    int? maxLength,
    bool shouldContainNumber = false,
    bool shouldContainSpecialChars = false,
    bool shouldContainCapitalLetter = false,
    bool shouldContainSmallLetter = false,
    Function? reason,
    String Function()? onNumberNotPresent,
    String Function()? onSpecialCharsNotPresent,
    String Function()? onCapitalLetterNotPresent,
  }) {
    return (fieldValue) {
      var mainError = errorMessage;

      if (Validator.isPassword(
        fieldValue,
        minLength: minLength,
        maxLength: maxLength,
        shouldContainSpecialChars: shouldContainSpecialChars,
        shouldContainCapitalLetter: shouldContainCapitalLetter,
        shouldContainSmallLetter: shouldContainSmallLetter,
        shouldContainNumber: shouldContainNumber,
        isNumberPresent: (present) {
          if (!present) mainError = onNumberNotPresent!();
        },
        isCapitalLetterPresent: (present) {
          if (!present) mainError = onCapitalLetterNotPresent!();
        },
        isSpecialCharsPresent: (present) {
          if (!present)
            mainError = onSpecialCharsNotPresent != null
                ? onSpecialCharsNotPresent()
                : "Password must contain special character";
        },
      )) {
        return null;
      } else {
        return mainError ?? "Password must match the required format";
      }
    };
  }

  static FormFieldValidator<String> equalTo(dynamic value, {String? message}) {
    return (fieldValue) {
      var valueToCompare;
      if (value is TextEditingController) {
        valueToCompare = value.text;
      } else {
        valueToCompare = value;
      }
      if (Validator.isEqualTo(fieldValue, valueToCompare)) {
        return null;
      } else {
        return message ?? "Values do not match";
      }
    };
  }

  static FormFieldValidator<String> notEqualTo(dynamic value, {String? message}) {
    return (fieldValue) {
      var valueToCompare;
      if (value is TextEditingController) {
        valueToCompare = value.text;
      } else {
        valueToCompare = value;
      }
      if (Validator.isNotEqualTo(fieldValue, valueToCompare)) {
        return null;
      } else {
        return message ?? "Values do match";
      }
    };
  }

  static FormFieldValidator<String> minLength(int minLength,
      {String? message}) {
    return (fieldValue) {
      if (Validator.minLength(fieldValue!, minLength)) {
        return null;
      } else {
        return message ?? "Field must be of minimum length of $minLength";
      }
    };
  }

  static FormFieldValidator<String> number(
      {bool noSymbols = true, String? message}) {
    return (fieldValue) {
      if (Validator.isNumber(fieldValue, allowSymbols: noSymbols)) {
        return null;
      } else {
        return message ?? "Field must be numbers only";
      }
    };
  }

  static FormFieldValidator<String> length(int minLength,
      {String? message}) {
    return (fieldValue) {
      if (Validator.length(fieldValue!, minLength)) {
        return null;
      } else {
        return message ?? "Field must be of $minLength characters.";
      }
    };
  }
}