// lib/auth_wrapper.dart
import 'package:eadta/screens/homeScreen.dart';
import 'package:eadta/screens/logingscreen.dart';
import 'package:eadta/services/localStorageServices.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final storage = context.watch<LocalStorageService>();
    debugPrint('AUTHWRAPPER REBUILD - isLoggedIn: ${storage.isLoggedIn}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (storage.isLoggedIn == true &&
          ModalRoute.of(context)?.isCurrent == true) {
        debugPrint('FORCE NAVIGATING TO HOME');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });

    if (storage.isLoading && storage.isLoggedIn == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return storage.isLoggedIn == true
        ? const HomeScreen()
        : const LoginScreen();
  }
}
