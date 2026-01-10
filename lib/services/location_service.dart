import 'package:cloud_firestore/cloud_firestore.dart';
import 'lib/models/location_model.dart';

class LocationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Update or create user location
  Future<void> updateLocation({
    required String userId,
    required double latitude,
    required double longitude,
  }) async {
    final docRef = _db.collection('locations').doc(userId);
    final location = LocationModel(
      userId: userId,
      currentLocation: GeoPoint(latitude, longitude),
      updatedAt: Timestamp.now(),
    );

    await docRef.set(location.toFirestore(), SetOptions(merge: true));
  }

  /// Get a user's location
  Future<LocationModel> getLocation(String userId) async {
    final doc = await _db.collection('locations').doc(userId).get();
    if (!doc.exists) throw Exception("Location not found");
    return LocationModel.fromFirestore(doc);
  }

  /// Stream nearby users (example: all users, filtering can be added later)
  Stream<List<LocationModel>> nearbyUsers() {
    return _db.collection('locations').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => LocationModel.fromFirestore(doc)).toList();
    });
  }
}
