import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static Future<User?> signInAnon() async {
    User? user = FirebaseAuth.instance.currentUser;
    user ??= (await FirebaseAuth.instance.signInAnonymously()).user;
    return user;
  }

  static Future<void> toggleFavorite(String eventId) async {
    final user = await signInAnon();
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    final userDoc = await userRef.get();

    if (userDoc.exists) {
      List<dynamic> favorites = userDoc['favorites'] ?? [];

      if (favorites.contains(eventId)) {
        // remove if already favorite
        favorites.remove(eventId);
      } else {
        // add if not favorite
        favorites.add(eventId);
      }

      await userRef.update({'favorites': favorites});
    } else {
      await userRef.set({
        'favorites': [eventId]
      });
    }
  }

  static Stream<List<String>> favoritesStream() async* {
    final user = await signInAnon();
    yield* FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data()!.containsKey('favorites')) {
        return List<String>.from(doc['favorites']);
      }
      return <String>[];
    });
  }
}
