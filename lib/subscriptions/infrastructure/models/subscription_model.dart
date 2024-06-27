class Subscription {
  final int? id; // Autoincremental en SQLite
  final String userId;
  final String clientSecret;
  final String plan;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  Subscription({
    this.id, // Opcional en SQLite (se autogenera)
    required this.userId,
    required this.clientSecret,
    required this.plan,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      clientSecret: json['client_secret'],
      userId: json['user_id'],
      plan: json['plan'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      isActive: json['is_active'],
    );
  }

  // Método para convertir de/a un mapa (para SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'clientSecret': clientSecret,
      'plan': plan,
      'startDate': startDate.toIso8601String(), 
      'endDate': endDate.toIso8601String(), 
      'isActive': isActive ? 1 : 0, // Convertir boolean a int
    };
  }

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'],
      userId: map['userId'],
      clientSecret: map['clientSecret'],
      plan: map['plan'],
      startDate: DateTime.parse(map['startDate']), // Convertir String a DateTime
      endDate: DateTime.parse(map['endDate']), 
      isActive: map['isActive'] == 1, // Convertir int a boolean
    );
  }
}