import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gotown/firebase_options.dart';
import 'package:gotown/screens/splashscreen/splashscreen.dart';
import 'package:gotown/utilities/const.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await deleteExpiredEventsBatch();
  await GetStorage.init();
  runApp(const MyApp());
}

final box = GetStorage();
Future<void> deleteExpiredEventsBatch() async {
  final now = Timestamp.now();

  final querySnapshot = await FirebaseFirestore.instance
      .collection('events')
      .where('expiryDate', isLessThanOrEqualTo: now)
      .get();

  print("Found ${querySnapshot.docs.length} expired docs.");

  WriteBatch batch = FirebaseFirestore.instance.batch();
  int counter = 0;

  for (var doc in querySnapshot.docs) {
    final eventId = doc.id;
    batch.delete(doc.reference);
    counter++;
    final usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('favorites', arrayContains: eventId)
        .get();

    for (var userDoc in usersSnapshot.docs) {
      batch.update(userDoc.reference, {
        'favorites': FieldValue.arrayRemove([eventId])
      });
    }
    if (counter % 500 == 0) {
      await batch.commit();
      print("Committed $counter deletes...");
      batch = FirebaseFirestore.instance.batch();
    }
  }

  if (counter % 500 != 0) {
    await batch.commit();
    print("Committed final ${counter % 500} deletes...");
  }

  print("Finished deleting $counter expired docs.");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GoTown',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'HelveticaNeue',
        scaffoldBackgroundColor: cbg,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
