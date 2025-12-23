import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SeederApp());
}

class SeederApp extends StatelessWidget {
  const SeederApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Firestore Seeder')),
        body: const SeederWidget(),
      ),
    );
  }
}

class SeederWidget extends StatefulWidget {
  const SeederWidget({super.key});

  @override
  State<SeederWidget> createState() => _SeederWidgetState();
}

class _SeederWidgetState extends State<SeederWidget> {
  String _status = 'Ready to Seed';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _boxes = [
    {
      'id': 'bnkr',
      'data': {
        'boxName': 'Box BNKR',
        'logoUrl': '',
        'primaryColor': '#E91E63', // Pink
        'secondaryColor': '#000000', // Black
      }
    },
    {
      'id': 'bruce',
      'data': {
        'boxName': 'Box Bruce',
        'logoUrl': '',
        'primaryColor': '#FF9800', // Orange
        'secondaryColor': '#000000', // Black
      }
    },
  ];

  Future<void> _seedBoxes() async {
    setState(() {
      _isLoading = true;
      _status = 'Seeding...';
    });

    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    try {
      for (var box in _boxes) {
        final docRef = firestore.collection('boxes').doc(box['id'] as String);
        batch.set(docRef, box['data']);
      }

      await batch.commit();

      setState(() {
        _status = 'Success! Added ${_boxes.length} boxes.';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_status, style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _seedBoxes,
                  child: const Text('Seed Boxes Collection'),
                ),
        ],
      ),
    );
  }
}
