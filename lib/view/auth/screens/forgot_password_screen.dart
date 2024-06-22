import 'package:budget_buddy/providers/auth_provider.dart';
import 'package:budget_buddy/utils/colors.dart';
import 'package:budget_buddy/utils/common.dart';
import 'package:budget_buddy/utils/common_widgets.dart';
import 'package:budget_buddy/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_rounded,
              size: 16,
            ),
          ),
          title: Text(
            "Forgot Password",
            style: boldTextStyle(fontSize: 14),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  largeVerticalSpace,
                  largeVerticalSpace,
                  Text(
                    "Forgot password",
                    textAlign: TextAlign.center,
                    style: boldTextStyle(fontSize: 14),
                  ),
                  smallVerticalSpace,
                  Text(
                    "Enter your email address below to receive a password reset link.",
                    textAlign: TextAlign.center,
                    style: secondaryTextStyle(),
                  ),
                  largeVerticalSpace,
                  largeVerticalSpace,
                  AppTextfield(
                    hintText: "Email address",
                    controller: emailController,
                    focusNode: emailFocus,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email address.';
                      }
                      if (!validateEmail(value)) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Image.asset(
                      "assets/icons/email_icon.png",
                      color: text2,
                    ),
                  ),
                  mediumVerticalSpace,
                  mediumVerticalSpace,
                  InkWell(
                    onTap: () async {
                      dismissKeyboard();
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      await authProvider.forgotPassword(
                        email: emailController.text.trim(),
                      );
                      if (context.mounted) {
                        if (authProvider.authStatus == Status.success) {
                          appToast(authProvider.message);
                          context.goNamed("signin_screen");
                        } else {
                          appToast(authProvider.message);
                        }
                      }
                    },
                    child: Container(
                      width: getScreenWidth(context),
                      height: 50,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text(
                          authProvider.authStatus == Status.loading
                              ? "Please wait..."
                              : "Send link",
                          style: boldTextStyle(
                            fontSize: 12,
                            color: appWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                  xlargeVerticalSpace,
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
