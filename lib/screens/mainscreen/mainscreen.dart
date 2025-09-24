import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gotown/screens/calenderscreen/calenderscreen.dart';
import 'package:gotown/screens/cityscreen/cityscreen.dart';
import 'package:gotown/screens/homescreen/homescreen.dart';
import 'package:gotown/screens/infoscreen/infoscreen.dart';
import 'package:gotown/utilities/const.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;

  final pages = [
    const HomeScreen(),
    const CallenderScreen(),
    const CityScreen(),
    const InfoScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Widget buildMyNavBar(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        height: MediaQuery.of(context).size.height * 0.066,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.004,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navItem('assets/home.png', "Menu", 0, isActive: pageIndex == 0),
              navItem('assets/callender.png', "Callendar", 1,
                  isActive: pageIndex == 1),
              navItem('assets/city.png', "City", 2, isActive: pageIndex == 2),
              navItem('assets/info.png', "Info", 3, isActive: pageIndex == 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem(String icon, String label, int index,
      {bool isActive = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          pageIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            color: isActive ? corange : cwhitetext,
            height: MediaQuery.of(context).size.height * 0.038,
          ),
          Text(
            label,
            style: TextStyle(
              height: 1.2,
              fontSize: 14,
              color: isActive ? corange : cwhitetext,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}
