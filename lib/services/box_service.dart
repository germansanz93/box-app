import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/box_branding.dart';

class BoxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _boxesCollection => _firestore.collection('boxes');

  // Fetch all available boxes for selection
  Future<List<Map<String, String>>> getBoxes() async {
    try {
      final querySnapshot = await _boxesCollection.get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'name': data['boxName'] as String? ?? 'Unknown Box',
        };
      }).toList();
    } catch (e) {
      // Handle errors or return empty list
      return [];
    }
  }

  // Fetch branding for a specific box
  Future<BoxBranding?> getBoxBranding(String boxId) async {
    try {
      final doc = await _boxesCollection.doc(boxId).get();
      if (doc.exists && doc.data() != null) {
        return BoxBranding.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
