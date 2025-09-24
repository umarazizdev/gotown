import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gotown/utilities/const.dart';
import 'package:intl/intl.dart';

import '../../models/eventmodel.dart';

class CallenderScreen extends StatefulWidget {
  const CallenderScreen({super.key});

  @override
  State<CallenderScreen> createState() => _CallenderScreenState();
}

class _CallenderScreenState extends State<CallenderScreen> {
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
              height: MediaQuery.of(context).size.height * 0.005,
            ),
            const Text(
              "Callendar",
              style: TextStyle(
                  color: cwhitetext, fontSize: 40, fontWeight: FontWeight.w500),
            ),
            // SizedBox(
            //   height: h * 0.018,
            // ),
            // const Text(
            //   "8:03",
            //   style: TextStyle(
            //       color: cwhitetext,
            //       fontSize: 15,
            //       fontWeight: FontWeight.w500,
            //       height: 0.7),
            // ),
            // const Divider(
            //   color: cwhitetext,
            // ),
            // const Text(
            //   "Concert xyz",
            //   style: TextStyle(
            //       height: 0.7,
            //       color: corange,
            //       fontSize: 15,
            //       fontWeight: FontWeight.w500),
            // ),
            // SizedBox(
            //   height: h * 0.005,
            // ),
            // const Text(
            //   "Sport Match ABC vs XYZ",
            //   style: TextStyle(
            //       color: cyellow, fontSize: 15, fontWeight: FontWeight.w500),
            // ),
            // SizedBox(
            //   height: h * 0.016,
            // ),
            // const Text(
            //   "11:03",
            //   style: TextStyle(
            //       height: 0.7,
            //       color: cwhitetext,
            //       fontSize: 15,
            //       fontWeight: FontWeight.w500),
            // ),
            // const Divider(
            //   color: cwhitetext,
            // ),
            // const Text(
            //   "Concert xyz",
            //   style: TextStyle(
            //       height: 0.7,
            //       color: cyellow,
            //       fontSize: 15,
            //       fontWeight: FontWeight.w500),
            // ),
            // SizedBox(
            //   height: h * 0.005,
            // ),
            // const Text(
            //   "Sport Match ABC vs XYZ",
            //   style: TextStyle(
            //       color: corange, fontSize: 15, fontWeight: FontWeight.w500),
            // ),
            // const Text(
            //   "Opera xyz",
            //   style: TextStyle(
            //       color: cpurpletext,
            //       fontSize: 15,
            //       fontWeight: FontWeight.w500),
            // ),
            // const Text(
            //   "Sport Match ABC vs XYZ",
            //   style: TextStyle(
            //       color: cyellow, fontSize: 15, fontWeight: FontWeight.w500),
            // ),
            // SizedBox(
            //   height: h * 0.016,
            // ),
            // const Text(
            //   "11:03",
            //   style: TextStyle(
            //       height: 0.7,
            //       color: cwhitetext,
            //       fontSize: 15,
            //       fontWeight: FontWeight.w500),
            // ),
            // const Divider(
            //   color: cwhitetext,
            // ),
            // const Text(
            //   "Theatre Retro",
            //   style: TextStyle(
            //       height: 0.7,
            //       color: cpurpletext,
            //       fontSize: 15,
            //       fontWeight: FontWeight.w500),
            // ),
            const Expanded(
              child: CalendarEventList(),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarEventList extends StatelessWidget {
  const CalendarEventList({super.key});

  Color getCategoryColor(String category) {
    switch (category) {
      case "Concert":
        return corange;
      case "Culture":
        return cyellow;
      case "Sport":
        return cpurple;
      default:
        return const Color(0xff3B4160);
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .orderBy('timestamp')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child:
                Text("No upcoming events", style: TextStyle(color: cwhitetext)),
          );
        }
        print("Loaded docs: ${snapshot.data!.docs.length}");

        final now = DateTime.now();
        final events = snapshot.data!.docs
            .map((doc) => Event.fromFirestore(doc))
            .where((event) {
          final eventDate = DateFormat('d MMMM y').parse(event.date);
          return !eventDate.isBefore(DateTime(now.year, now.month, now.day));
        }).toList();

        return ListView.separated(
          itemCount: events.length,
          separatorBuilder: (context, index) => SizedBox(height: h * 0.018),
          itemBuilder: (context, index) {
            final event = events[index];
            final categoryColor = getCategoryColor(event.category);
            final parsedDate = DateFormat('d MMMM y').parse(event.date);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('d MM').format(parsedDate).toUpperCase(),
                  style: const TextStyle(
                    color: cwhitetext,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 0.7,
                  ),
                ),
                const Divider(color: cwhitetext),
                Text(
                  event.title,
                  style: TextStyle(
                    height: 0.7,
                    color: categoryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
