
import 'package:chapa_tu_bus_app/account_management/presentation/screens/auth/log_in_screen.dart';
import 'package:chapa_tu_bus_app/account_management/presentation/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';

class LogInOrRegisterScreen extends StatefulWidget {
  const LogInOrRegisterScreen({super.key});

  @override
  State<LogInOrRegisterScreen> createState() => _LogInOrRegisterScreenState();
}

class _LogInOrRegisterScreenState extends State<LogInOrRegisterScreen> {
  //initially show login page
  bool showLoginScreen = true;

  // toggle between login and register screens
  void toggleScreens() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    if (showLoginScreen) {
      return LogInScreen(onTap: toggleScreens);
    } else {
      return RegisterScreen(onTap: toggleScreens);
    }
  }
}