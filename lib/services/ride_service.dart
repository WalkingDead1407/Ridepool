import 'package:cloud_firestore/cloud_firestore.dart';
import 'lib/models/ride_model.dart';
import 'lib/utils/price_utils.dart';

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

      if (ride.joinedUserIds.contains(userId)) {
        throw Exception("User already joined");
      }

      final updatedJoined = List<String>.from(ride.joinedUserIds)..add(userId);
      final newAvailableSeats = ride.availableSeats - 1;

      final newPricePerPerson = PriceUtils.pricePerPerson(
        totalPrice: ride.totalPrice,
        totalSeats: ride.totalSeats,
        availableSeats: newAvailableSeats,
      );

      transaction.update(docRef, {
        'availableSeats': newAvailableSeats,
        'joinedUserIds': updatedJoined,
        'pricePerPerson': newPricePerPerson,
      });
    });
  }

  /// Leave a ride
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

      final updatedJoined =
          List<String>.from(ride.joinedUserIds)..remove(userId);
      final newAvailableSeats = ride.availableSeats + 1;

      final newPricePerPerson = PriceUtils.pricePerPerson(
        totalPrice: ride.totalPrice,
        totalSeats: ride.totalSeats,
        availableSeats: newAvailableSeats,
      );

      transaction.update(docRef, {
        'availableSeats': newAvailableSeats,
        'joinedUserIds': updatedJoined,
        'pricePerPerson': newPricePerPerson,
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
