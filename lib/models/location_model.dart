import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel {
  final String userId;
  final GeoPoint currentLocation;
  final Timestamp updatedAt;

  LocationModel({
    required this.userId,
    required this.currentLocation,
    required this.updatedAt,
  });

  /// Convert Firestore → LocationModel
  factory LocationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LocationModel(
      userId: doc.id,
      currentLocation: data['currentLocation'],
      updatedAt: data['updatedAt'],
    );
  }

  /// Convert LocationModel → Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'currentLocation': currentLocation,
      'updatedAt': updatedAt,
    };
  }
}
