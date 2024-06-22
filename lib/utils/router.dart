import 'package:budget_buddy/view/auth/screens/forgot_password_screen.dart';
import 'package:budget_buddy/view/auth/screens/sign_in_screen.dart';
import 'package:budget_buddy/view/auth/screens/sign_up_screen.dart';
import 'package:budget_buddy/view/home/screens/dashboard_screen.dart';
import 'package:budget_buddy/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/signin_screen',
      name: 'signin_screen',
      builder: (BuildContext context, GoRouterState state) {
        return const SignInScreen();
      },
    ),
    GoRoute(
      path: '/signup_screen',
      name: 'signup_screen',
      builder: (BuildContext context, GoRouterState state) {
        return const SignUpScreen();
      },
    ),
    GoRoute(
      path: '/forgot_password_screen',
      name: 'forgot_password_screen',
      builder: (BuildContext context, GoRouterState state) {
        return const ForgotPasswordScreen();
      },
    ),
    GoRoute(
      path: '/dashboard_screen',
      name: 'dashboard_screen',
      builder: (BuildContext context, GoRouterState state) {
        return DashboardScreen();
      },
    ),
  ],
);
