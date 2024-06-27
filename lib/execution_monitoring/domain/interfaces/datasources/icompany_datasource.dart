import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/company.dart';

abstract class CompanyDataSource {
  Future<List<Company>> getAllCompanies({required String token});
}