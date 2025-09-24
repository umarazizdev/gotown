import 'package:flutter/material.dart';
import 'package:gotown/utilities/const.dart';

import '../../main.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: h * 0.055,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Hello ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: cwhite,
                        fontSize: 22,
                      ),
                    ),
                    TextSpan(
                      text: box.read('selectedCity') ?? 'Wroclaw',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: cwhitetext,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            const Text(
              "Info",
              style: TextStyle(
                  color: cwhitetext, fontSize: 26, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: h * 0.005,
            ),
            const Text(
              "Contact",
              style: TextStyle(
                  height: 0.7,
                  color: cwhitetext,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w500),
            ),
            const Divider(
              color: cwhitetext,
            ),
            const Text(
              "hellogotown@gmail.com",
              style: TextStyle(
                  height: 0.7,
                  color: cblue,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: h * 0.03,
            ),
            const Text(
              "Version",
              style: TextStyle(
                  height: 0.7,
                  color: cwhitetext,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w500),
            ),
            const Divider(
              color: cwhitetext,
            ),
            const Text(
              "v.1",
              style: TextStyle(
                  height: 0.7,
                  color: corange,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
