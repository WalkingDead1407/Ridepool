class PriceUtils {
  /// Calculate price per person
  static double pricePerPerson({
    required double totalPrice,
    required int totalSeats,
    required int availableSeats,
  }) {
    final joinedPeople = totalSeats - availableSeats;

    if (joinedPeople <= 0) return totalPrice;

    return double.parse(
      (totalPrice / joinedPeople).toStringAsFixed(2),
    );
  }
}
