import 'package:cloud_firestore/cloud_firestore.dart';

class Ride {
  final String id;
  final String ownerId;

  final String fromLocation;
  final String toLocation;

  final GeoPoint fromGeo;
  final GeoPoint toGeo;

  final int totalSeats;
  final int availableSeats;

  final double totalPrice;
  final double pricePerPerson;

  final List<String> joinedUserIds;

  final Timestamp createdAt;

  Ride({
    required this.id,
    required this.ownerId,
    required this.fromLocation,
    required this.toLocation,
    required this.fromGeo,
    required this.toGeo,
    required this.totalSeats,
    required this.availableSeats,
    required this.totalPrice,
    required this.pricePerPerson,
    required this.joinedUserIds,
    required this.createdAt,
  });

  /// Convert Firestore → Ride object
  factory Ride.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Ride(
      id: doc.id,
      ownerId: data['ownerId'],
      fromLocation: data['fromLocation'],
      toLocation: data['toLocation'],
      fromGeo: data['fromGeo'],
      toGeo: data['toGeo'],
      totalSeats: data['totalSeats'],
      availableSeats: data['availableSeats'],
      totalPrice: (data['totalPrice'] as num).toDouble(),
      pricePerPerson: (data['pricePerPerson'] as num).toDouble(),
      joinedUserIds: List<String>.from(data['joinedUserIds']),
      createdAt: data['createdAt'],
    );
  }

  /// Convert Ride object → Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'fromLocation': fromLocation,
      'toLocation': toLocation,
      'fromGeo': fromGeo,
      'toGeo': toGeo,
      'totalSeats': totalSeats,
      'availableSeats': availableSeats,
      'totalPrice': totalPrice,
      'pricePerPerson': pricePerPerson,
      'joinedUserIds': joinedUserIds,
      'createdAt': createdAt,
    };
  }
}
