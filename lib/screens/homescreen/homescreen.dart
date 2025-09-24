import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gotown/main.dart';
import 'package:gotown/models/eventmodel.dart';
import 'package:gotown/screens/homescreen/detailscreen.dart';
import 'package:gotown/services/userservice.dart';
import 'package:gotown/utilities/const.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final List<String> categories = const ["Concert", "Culture", "Sport"];
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        backgroundColor: cbg,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: h * 0.055),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Hello ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    TextSpan(
                      text: box.read('selectedCity') ?? 'Wrocław',
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
            SizedBox(height: h * 0.03),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.09),
              child: CustomCategoryTabBar(
                categories: categories,
                selectedIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                    _tabController.animateTo(index);
                  });
                },
              ),
            ),
            SizedBox(height: h * 0.025),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: categories.map((category) {
                  return EventListView(category: category);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _getTabColor(String category) {
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

class EventListView extends StatelessWidget {
  final String category;
  const EventListView({super.key, required this.category});

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
    final now = DateTime.now();
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .where('category', isEqualTo: category)
          .where('expiryDate', isGreaterThan: now)
          .where('city',
              isEqualTo:
                  (box.read('selectedCity') ?? 'Wrocław').toString().trim())
          // .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text(
                  "No event availabe for this category in upcoming days",
                  style: TextStyle(color: Colors.white)));
        }

        final events = snapshot.data!.docs.map((doc) {
          return Event.fromFirestore(doc);
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            final parsedDate = DateFormat('d MMMM y').parse(event.date);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(
                      event: event,
                    ),
                  ),
                );
              },
              child: Card(
                color: const Color(0xFF2E2F4D),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22)),
                margin: const EdgeInsets.only(bottom: 13),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.network(
                        event.images.isNotEmpty
                            ? event.images.first
                            : 'https://www.rosalievillage.co/wp-content/uploads/2022/09/placeholder.png',
                        height: h * 0.388,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        // loadingBuilder: (context, child, loadingProgress) {
                        //   if (loadingProgress == null) return child;
                        //   return Image.asset(
                        //     'assets/placeholder-image.png',
                        //     height: h * 0.388,
                        //     width: double.infinity,
                        //     fit: BoxFit.cover,
                        //   );
                        // },
                        // errorBuilder: (context, error, stackTrace) {
                        //   return Image.asset(
                        //     'assets/placeholder-image.png',
                        //     height: h * 0.388,
                        //     width: double.infinity,
                        //     fit: BoxFit.cover,
                        //   );
                        // },
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: h * 0.388,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xfffdfdfd).withOpacity(0.1),
                              cbg,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: StreamBuilder<List<String>>(
                        stream: UserService.favoritesStream(),
                        builder: (context, snapshot) {
                          final favorites = snapshot.data ?? [];
                          final isFav = favorites.contains(event.id);

                          return Container(
                            padding: const EdgeInsets.all(0),
                            decoration: const BoxDecoration(
                              color: cbg,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                UserService.toggleFavorite(event.id);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(
                          color: cbg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              DateFormat('d').format(parsedDate),
                              style: TextStyle(
                                fontSize: 18,
                                height: 1.2,
                                fontWeight: FontWeight.bold,
                                color: getCategoryColor(category),
                              ),
                            ),
                            Text(
                              DateFormat('MMM')
                                  .format(parsedDate)
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 14,
                                color: getCategoryColor(category),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 47,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: getCategoryColor(event.category),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          event.category,
                          style: TextStyle(
                            color:
                                event.category == 'Concert' ? cwhitetext : cbg,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      left: 12,
                      right: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(
                              color: cwhitetext,
                              fontSize: 20,
                              letterSpacing: 0.01,
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                event.place,
                                style: const TextStyle(
                                    fontSize: 14.5,
                                    height: 1,
                                    color: cwhitetext),
                              ),
                              Text(
                                event.city,
                                style: const TextStyle(
                                    fontSize: 12, height: 1, color: cwhitetext),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CustomCategoryTabBar extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final Function(int) onTap;

  const CustomCategoryTabBar({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.045),
      height: MediaQuery.of(context).size.height * 0.038,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) =>
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = index == selectedIndex;
          final color = _getTabColor(cat);
          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04),
              decoration: BoxDecoration(
                color: isSelected ? color : clbg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  cat,
                  style: TextStyle(
                    color: isSelected
                        ? (cat == 'Concert' ? cwhitetext : cbg)
                        : cwhitetext,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
