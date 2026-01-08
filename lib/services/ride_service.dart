import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ride_model.dart';

class RideService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Create a new ride
  Future<void> createRide(Ride ride) async {
    await _db.collection('rides').doc(ride.id).set(ride.toFirestore());
  }

  /// Join an existing ride
  Future<void> joinRide({
    required String rideId,
    required String userId,
  }) async {
    final docRef = _db.collection('rides').doc(rideId);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw Exception("Ride does not exist");
      }

      final ride = Ride.fromFirestore(snapshot);

      if (ride.availableSeats <= 0) {
        throw Exception("No available seats");
      }

      // Update seats and joined users
      final updatedJoined = List<String>.from(ride.joinedUserIds)..add(userId);
      transaction.update(docRef, {
        'availableSeats': ride.availableSeats - 1,
        'joinedUserIds': updatedJoined,
      });
    });
  }

  /// Leave a ride (optional, in case user cancels)
  Future<void> leaveRide({
    required String rideId,
    required String userId,
  }) async {
    final docRef = _db.collection('rides').doc(rideId);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw Exception("Ride does not exist");
      }

      final ride = Ride.fromFirestore(snapshot);

      if (!ride.joinedUserIds.contains(userId)) {
        throw Exception("User is not part of this ride");
      }

      // Update seats and joined users
      final updatedJoined = List<String>.from(ride.joinedUserIds)..remove(userId);
      transaction.update(docRef, {
        'availableSeats': ride.availableSeats + 1,
        'joinedUserIds': updatedJoined,
      });
    });
  }

  /// Get ride by ID
  Future<Ride> getRide(String rideId) async {
    final doc = await _db.collection('rides').doc(rideId).get();
    if (!doc.exists) throw Exception("Ride not found");
    return Ride.fromFirestore(doc);
  }
}
