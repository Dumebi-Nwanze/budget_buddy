import 'package:budget_buddy/providers/auth_provider.dart';
import 'package:budget_buddy/utils/colors.dart';
import 'package:budget_buddy/utils/common.dart';
import 'package:budget_buddy/utils/common_widgets.dart';
import 'package:budget_buddy/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode fnameFocus = FocusNode();
  FocusNode cpasswordFocus = FocusNode();
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
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                largeVerticalSpace,
                Image.asset(
                  "assets/icons/app_logo.png",
                  height: 50,
                  width: 50,
                ),
                largeVerticalSpace,
                Text(
                  "Create an account",
                  style: boldTextStyle(),
                ),
                smallVerticalSpace,
                Text(
                  "Register with your email and password to use Budget Buddy.",
                  style: secondaryTextStyle(),
                ),
                largeVerticalSpace,
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      AppTextfield(
                        hintText: "Full name",
                        controller: fnameController,
                        focusNode: fnameFocus,
                        keyboardType: TextInputType.name,
                        validator: (val) {
                          if (val!.isEmpty ||
                              val.trim().split(" ").length < 2) {
                            return "Please enter your full name.";
                          }
                          return null;
                        },
                        prefixIcon: Image.asset(
                          "assets/icons/email_icon.png",
                          color: text2,
                        ),
                      ),
                      mediumVerticalSpace,
                      AppTextfield(
                        hintText: "Email address",
                        controller: emailController,
                        focusNode: emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email address.';
                          }
                          if (!validateEmail(value)) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        prefixIcon: Image.asset(
                          "assets/icons/email_icon.png",
                          color: text2,
                        ),
                      ),
                      mediumVerticalSpace,
                      AppTextfield(
                        hintText: "Password",
                        controller: passwordController,
                        focusNode: passwordFocus,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters.';
                          }
                          return null;
                        },
                        prefixIcon: Image.asset(
                          "assets/icons/lock_icon.png",
                          color: text2,
                        ),
                        isPassword: true,
                      ),
                      mediumVerticalSpace,
                      AppTextfield(
                        hintText: "Confirm password",
                        controller: cpasswordController,
                        validator: (val) {
                          if (val != passwordController.text) {
                            return "Passwords must match";
                          }
                          return null;
                        },
                        focusNode: cpasswordFocus,
                        keyboardType: TextInputType.text,
                        prefixIcon: Image.asset(
                          "assets/icons/lock_icon.png",
                          color: text2,
                        ),
                        isPassword: true,
                      ),
                      mediumVerticalSpace,
                      mediumVerticalSpace,
                      InkWell(
                        onTap: () async {
                          dismissKeyboard();
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          await authProvider.signUp(
                            fullname: fnameController.text.trim(),
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                          if (context.mounted) {
                            if (authProvider.authStatus == Status.success) {
                              appToast(authProvider.message);
                              context.goNamed("dashboard_screen");
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
                                  : "Sign up",
                              style: boldTextStyle(
                                fontSize: 12,
                                color: appWhite,
                              ),
                            ),
                          ),
                        ),
                      ),
                      xlargeVerticalSpace,
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have an account? ',
                              style: secondaryTextStyle(),
                            ),
                            TextSpan(
                              text: 'Sign in',
                              style: boldTextStyle(color: text1, fontSize: 12),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.goNamed("signin_screen");
                                },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
