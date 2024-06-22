import 'package:budget_buddy/providers/auth_provider.dart';
import 'package:budget_buddy/utils/colors.dart';
import 'package:budget_buddy/utils/common.dart';
import 'package:budget_buddy/utils/common_widgets.dart';
import 'package:budget_buddy/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  final formKey = GlobalKey<FormState>();

  final validators = [
    (value) {
      if (value.isEmpty) {
        return 'Please enter your email address.';
      }
      if (!validateEmail(value)) {
        return 'Please enter a valid email address.';
      }
      return null;
    },
    (value) {
      if (value.isEmpty) {
        return 'Please enter your password';
      }
      if (value.length < 8) {
        return 'Password must be at least 8 characters.';
      }
      return null;
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      return Scaffold(
        appBar: AppBar(),
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
                "Welcome Back!",
                style: boldTextStyle(),
              ),
              smallVerticalSpace,
              Text(
                "We are happy to see you here again. Sign in securely with your email and password",
                style: secondaryTextStyle(),
              ),
              largeVerticalSpace,
              Form(
                key: formKey,
                child: Column(
                  children: [
                    AppTextfield(
                      hintText: "Email address",
                      controller: emailController,
                      focusNode: emailFocus,
                      validator: validators[0],
                      keyboardType: TextInputType.emailAddress,
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
                      validator: validators[1],
                      keyboardType: TextInputType.text,
                      prefixIcon: Image.asset(
                        "assets/icons/lock_icon.png",
                        color: text2,
                      ),
                      isPassword: true,
                    ),
                    mediumVerticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.pushNamed("forgot_password_screen");
                          },
                          child: Text(
                            "Forgot password?",
                            style: secondaryTextStyle(),
                          ),
                        )
                      ],
                    ),
                    mediumVerticalSpace,
                    InkWell(
                      onTap: () async {
                        dismissKeyboard();
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        await authProvider.signIn(
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
                                : "Sign in",
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
                            text: 'Don\'t have an account? ',
                            style: secondaryTextStyle(),
                          ),
                          TextSpan(
                            text: 'Sign up',
                            style: boldTextStyle(color: text1, fontSize: 12),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.pushNamed("signup_screen");
                              },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )),
      );
    });
  }
}
