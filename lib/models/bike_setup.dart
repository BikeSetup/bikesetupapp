import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bikesetupapp/database_service/firestore_keys.dart';

class BikeSetup {
  final String id;
  final String name;

  const BikeSetup({required this.id, required this.name});

  factory BikeSetup.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return BikeSetup(
      id: doc.id,
      name: data[FirestoreKeys.setupName] as String? ?? '',
    );
  }
}
