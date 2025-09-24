import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gotown/main.dart';
import 'package:gotown/services/userservice.dart';
import 'package:gotown/utilities/const.dart';
import 'package:intl/intl.dart';

import '../../models/eventmodel.dart';

class CallenderScreen extends StatefulWidget {
  const CallenderScreen({super.key});

  @override
  State<CallenderScreen> createState() => _CallenderScreenState();
}

class _CallenderScreenState extends State<CallenderScreen> {
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
                      text: box.read('selectedCity'),
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
              height: MediaQuery.of(context).size.height * 0.005,
            ),
            const Text(
              "Callendar",
              style: TextStyle(
                  color: cwhitetext, fontSize: 40, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: h * 0.018,
            ),
            StreamBuilder<List<String>>(
              stream: UserService.favoritesStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final favIds = snapshot.data!;
                if (favIds.isEmpty) {
                  return const Center(
                      child: Text("No favorites yet",
                          style: TextStyle(color: Colors.white)));
                }

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('events')
                      .where(FieldPath.documentId, whereIn: favIds)
                      .snapshots(),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final favEvents = snap.data!.docs.map((doc) {
                      return Event.fromFirestore(doc);
                    }).toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0),
                      itemCount: favEvents.length,
                      itemBuilder: (context, index) {
                        final event = favEvents[index];

                        DateTime parsedDate =
                            DateFormat('d MMMM y').parse(event.date);
                        String formattedDay =
                            DateFormat('d:MM').format(parsedDate);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formattedDay,
                              style: const TextStyle(
                                color: cwhitetext,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                height: 0.7,
                              ),
                            ),
                            const Divider(color: cwhitetext),
                            Text(
                              event.category,
                              style: TextStyle(
                                height: 0.7,
                                color: getCategoryColor(event.category),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
