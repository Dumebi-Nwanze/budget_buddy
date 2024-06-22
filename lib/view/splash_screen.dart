import 'package:budget_buddy/main.dart';
import 'package:budget_buddy/models/user_model.dart';
import 'package:budget_buddy/providers/auth_provider.dart';
import 'package:budget_buddy/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = sharedPrefs?.getString("user");
      if (user != null) {
        final UserModel userModel = UserModel.fromJson(user);
        context.read<AuthProvider>().user = userModel;
        Future.delayed(Duration(seconds: 2), () {
          context.goNamed("dashboard_screen");
        });
      } else {
        context.goNamed("signin_screen");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/app_logo.png",
              height: 100,
              width: 100,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              "Budget Buddy",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: secondaryColor,
                fontSize: 24,
              ),
            )
          ],
        ),
      ),
    );
  }
}
