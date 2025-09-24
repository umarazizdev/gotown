import 'package:flutter/material.dart';
import 'package:gotown/utilities/const.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  bool isChecked = true;
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
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hello ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: cwhite,
                        fontSize: 22,
                      ),
                    ),
                    TextSpan(
                      text: 'Wroclaw',
                      style: TextStyle(
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
              "City",
              style: TextStyle(
                  color: cwhitetext, fontSize: 26, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: h * 0.005,
            ),
            Container(
              margin: const EdgeInsets.all(4),
              height: h * 0.06,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: clbg, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                    side: const BorderSide(color: corange, width: 2),
                    activeColor: corange,
                    checkColor: Colors.white,
                  ),
                  const Text(
                    "Wroclaw",
                    style: TextStyle(
                      color: cwhitetext,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                "More city Coming soon",
                style: TextStyle(
                  color: Color(0xff7896cc),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: h * 0.04,
            )
          ],
        ),
      ),
    );
  }
}
