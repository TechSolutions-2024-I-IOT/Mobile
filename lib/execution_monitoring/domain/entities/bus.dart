class Bus {
  final int id;
  final String licensePlate;
  final int seatingCapacity;
  final int totalCapacity;
  final int year;
  final String state;
  final int userId; // Changed to userId for clarity
  final bool isDeleted;

  Bus({
    required this.id,
    required this.licensePlate,
    required this.seatingCapacity,
    required this.totalCapacity,
    required this.year,
    required this.state,
    required this.userId,
    required this.isDeleted,
  });
}