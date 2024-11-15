import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_transport_budget_95t/bottom_route.dart';
import 'package:my_transport_budget_95t/settings/splash_screen/onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();

    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    var box = await Hive.openBox('appBox');

    bool isFirstLaunch = box.get('isFirstLaunch', defaultValue: true);

    await Future.delayed(const Duration(seconds: 2));

    if (isFirstLaunch) {
      await box.put('isFirstLaunch', false);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ButtomRoute()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff070707),
      body: Center(
        child: Image.asset(
          'assets/images/app icon.png',
          width: 241,
          height: 241,
        ),
      ),
    );
  }
}
