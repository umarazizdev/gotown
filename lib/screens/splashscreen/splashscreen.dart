import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotown/screens/mainscreen/mainscreen.dart';
import 'package:gotown/screens/splashscreen/linearindicator.dart';
import 'package:gotown/utilities/const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
        const Duration(
          seconds: 2,
        ),
        () => Get.to(const MainScreen()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cbg,
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.2,
              width: MediaQuery.of(context).size.width / 1.05,
              child: Image.asset(
                'assets/splashlogo.png',
              ),
            ),
            const MyIndicator(),

            // const SpinKitWaveSpinner(
            //   color: Color(0xFFC6D22F),
            //   trackColor: Color(0xFF2E2F4D),
            //   waveColor: Color(0xFF4C9A2A),
            //   size: 90.0,
            // )
          ],
        ),
      )),
    );
  }
}
