import 'package:budget_buddy/utils/colors.dart';
import 'package:budget_buddy/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppTextfield extends StatefulWidget {
  AppTextfield({
    super.key,
    required this.controller,
    required this.keyboardType,
    this.prefixIcon,
    this.isPassword = false,
    required this.focusNode,
    required this.hintText,
    this.validator,
  });

  TextEditingController controller;
  TextInputType keyboardType;
  Widget? prefixIcon;
  bool isPassword;
  FocusNode focusNode;
  String hintText;
  String? Function(String?)? validator;

  @override
  State<AppTextfield> createState() => _AppTextfieldState();
}

class _AppTextfieldState extends State<AppTextfield> {
  bool hidePassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: widget.isPassword ? hidePassword : false,
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      style: secondaryTextStyle(),
      cursorHeight: 16,
      cursorColor: secondaryColor,
      decoration: InputDecoration(
        prefixIconConstraints: widget.prefixIcon == null
            ? null
            : const BoxConstraints(
                maxHeight: 32,
                maxWidth: 40,
              ),
        prefixIcon: widget.prefixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8,
                ),
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: widget.prefixIcon,
                ),
              ),
        suffixIconConstraints: widget.isPassword
            ? const BoxConstraints(
                maxHeight: 32,
                maxWidth: 40,
              )
            : null,
        suffixIcon: widget.isPassword
            ? Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8,
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: hidePassword
                        ? const Icon(
                            CupertinoIcons.eye,
                            color: text2,
                          )
                        : const Icon(
                            CupertinoIcons.eye_slash,
                            color: text2,
                          ),
                  ),
                ),
              )
            : null,
        filled: true,
        fillColor: textFieldbg,
        hintText: widget.hintText,
        hintStyle: secondaryTextStyle(),
        errorStyle: secondaryTextStyle(color: appRed),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: text2, width: 2),
            borderRadius: BorderRadius.circular(12)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: appRed, width: 2),
            borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

void appToast(String message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      textColor: Colors.white,
      fontSize: 12);
}
