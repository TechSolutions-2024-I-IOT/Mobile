

import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/user_company.dart';

class Company {
  final int id;
  final String name;
  final String busImageUrl;
  final String logoImageUrl;
  final String description;
  final UserCompany user;
  final bool isDeleted;

  Company({
    required this.id,
    required this.name,
    required this.busImageUrl,
    required this.logoImageUrl,
    required this.description,
    required this.user,
    required this.isDeleted,
  });
}
