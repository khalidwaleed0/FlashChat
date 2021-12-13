import 'package:flutter/foundation.dart';

class Validator extends ChangeNotifier {
  Validator._privateConstructor();
  static final Validator _instance = Validator._privateConstructor();
  factory Validator() {
    return _instance;
  }
  bool hasValidEmail = false;
  bool hasEnoughLength = false;
  bool hasOneSmallChar = false;
  bool hasOneCapitalChar = false;
  bool hasOneNumber = false;
  bool hasOneSymbol = false;
  bool isEverythingValid = false;

  void validateEmail(String email) {
    RegExp regExp = RegExp('(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9_.+-]+\\.[a-zA-Z0-9-.]+)');
    hasValidEmail = regExp.hasMatch(email) ? true : false;
    checkOverallValidation();
    notifyListeners();
  }

  void validatePassword(String password) {
    hasEnoughLength = password.length >= 8 ? true : false;
    hasOneSmallChar = RegExp('[a-z]').hasMatch(password) ? true : false;
    hasOneCapitalChar = RegExp('[A-Z]').hasMatch(password) ? true : false;
    hasOneNumber = RegExp('\\d').hasMatch(password) ? true : false;
    hasOneSymbol = RegExp('\\W').hasMatch(password) ? true : false;
    checkOverallValidation();
    notifyListeners();
  }

  void checkOverallValidation() {
    if (hasValidEmail &&
        hasEnoughLength &&
        hasOneSmallChar &&
        hasOneCapitalChar &&
        hasOneNumber &&
        hasOneSymbol)
      isEverythingValid = true;
    else
      isEverythingValid = false;
  }
}
