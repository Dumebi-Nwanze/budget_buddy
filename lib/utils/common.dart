import 'package:budget_buddy/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

TextStyle boldTextStyle({
  Color? color,
  double? fontSize,
}) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: fontSize ?? 24,
    color: color ?? text1,
  );
}

TextStyle secondaryTextStyle({
  Color? color,
  double? fontSize,
  bool underline = false,
}) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: fontSize ?? 12,
    color: color ?? text2,
    decoration: underline ? TextDecoration.underline : TextDecoration.none,
  );
}

bool validateEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    caseSensitive: false,
    multiLine: false,
  );
  return emailRegex.hasMatch(email);
}

bool validatePassword(String password) {
  if (password.length < 8) {
    return false;
  }

  return true;
}

enum Status {
  initial,
  loading,
  success,
  failed,
  noNetwork,
}

class NetworkResponse {
  final Status status;
  final String message;
  final dynamic data;

  const NetworkResponse({required this.status, this.message = "", this.data});
}

setStatusBarColor(Color color) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: color,
  ));
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

void dismissKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

var logger = Logger();

int calculateCreditScore(double ratio) {
  if (ratio >= 1) {
    return (600 + (250 * (ratio - 1) / ratio)).toInt().clamp(600, 850);
  } else {
    return (600 - (300 * (1 - ratio))).toInt().clamp(300, 599);
  }
}

String getOrdinal(double number) {
  int intNum = number.toInt();
  if (!(intNum >= 1 && intNum <= 31)) return intNum.toString();

  if (intNum % 10 == 1 && intNum % 100 != 11) {
    return "${intNum}st";
  } else if (intNum % 10 == 2 && intNum % 100 != 12) {
    return "${intNum}nd";
  } else if (intNum % 10 == 3 && intNum % 100 != 13) {
    return "${intNum}rd";
  } else {
    return "${intNum}th";
  }
}
