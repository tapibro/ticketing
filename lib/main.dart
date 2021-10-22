import 'package:flutter/material.dart';
import 'constants.dart' as Constants;
import 'routes/landing.dart';
import 'routes/login.dart';
import 'routes/dashboard.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: Constants.APP_NAME, initialRoute: '/', routes: {
      '/': (context) => const LandingRoute(),
      '/login': (context) => const LoginRoute(),
      '/dashboard': (context) => const DashboardRoute()
    });
  }
}
