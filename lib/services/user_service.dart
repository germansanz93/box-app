import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _users => _db.collection('users');

  /// Creates a new user document in Firestore with a default role
  Future<void> createUserDocument(User user, {String role = 'athlete'}) async {
    try {
      await _users.doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
        'displayName': user.displayName ?? user.email?.split('@')[0],
      });
    } catch (e) {
      print('Error creating user document: $e');
      rethrow;
    }
  }

  /// Fetches the user's role from Firestore
  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot doc = await _users.doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return (doc.data() as Map<String, dynamic>)['role'] as String?;
      }
      return null;
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }
}
