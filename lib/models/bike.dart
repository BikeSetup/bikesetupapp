import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bikesetupapp/database_service/firestore_keys.dart';

class Bike {
  final String id;
  final String name;
  final String bikeType;

  const Bike({required this.id, required this.name, required this.bikeType});

  factory Bike.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Bike(
      id: doc.id,
      name: data[FirestoreKeys.bikeName] as String? ?? '',
      bikeType: data[FirestoreKeys.bikeType] as String? ?? '',
    );
  }
}
