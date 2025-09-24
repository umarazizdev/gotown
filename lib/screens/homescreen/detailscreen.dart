import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotown/models/eventmodel.dart';
import 'package:gotown/screens/homescreen/homescreen.dart';
import 'package:gotown/utilities/const.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
  final Event event;

  const DetailScreen({super.key, required this.event});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final parsedDate = DateFormat('d MMMM y').parse(widget.event.date);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  widget.event.images.isNotEmpty
                      ? widget.event.images.first
                      : 'https://via.placeholder.com/400',
                  height: h * 0.48,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: -2,
                  left: 0,
                  right: 0,
                  height: h * 0.4,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [cbg.withOpacity(0.05), cbg],
                        // colors: [cwhite.withOpacity(0.05), cbg],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        overlayColor:
                            const WidgetStatePropertyAll(Colors.transparent),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              color: cblue,
                            ),
                            Text(
                              "Back",
                              style: TextStyle(color: cblue, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 35,
                  left: 14,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              color: getCategoryColor(widget.event.category),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.event.category,
                              style: TextStyle(
                                color: widget.event.category == 'Concert'
                                    ? cwhitetext
                                    : cgreytext,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "${DateFormat('d').format(parsedDate)} ",
                                  style: TextStyle(
                                    fontSize: 19,
                                    height: 1,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        getCategoryColor(widget.event.category),
                                  ),
                                ),
                                TextSpan(
                                  text: DateFormat('MMMM')
                                      .format(parsedDate)
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 19,
                                    height: 1,
                                    color:
                                        getCategoryColor(widget.event.category),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  left: 14,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          widget.event.title,
                          style: const TextStyle(
                            color: cwhitetext,
                            fontSize: 21,
                            letterSpacing: 0.01,
                            fontWeight: FontWeight.w500,
                            height: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.event.time,
                        style: const TextStyle(
                          color: cwhitetext,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 1),

            // Location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.event.place}, ${widget.event.city}",
                  style: const TextStyle(
                      fontSize: 14, height: 1, color: cwhitetext),
                ),
              ),
            ),
            SizedBox(
              height: h * 0.003,
            ),
// Date widget
            // Padding(
            //   padding: const EdgeInsets.only(right: 14),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       Text(
            //         DateFormat('d').format(parsedDate),
            //         style: TextStyle(
            //           fontSize: 18,
            //           height: 1,
            //           fontWeight: FontWeight.bold,
            //           color: getCategoryColor(widget.event.category),
            //         ),
            //       ),
            //       const SizedBox(width: 4),
            //       Text(
            //         DateFormat('MMMM').format(parsedDate).toUpperCase(),
            //         style: TextStyle(
            //           fontSize: 18,
            //           height: 1,
            //           color: getCategoryColor(widget.event.category),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Text(
                widget.event.text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: cwhitetext,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

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
