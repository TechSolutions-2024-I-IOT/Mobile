import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/company.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/interfaces/repositories/icompany_repository.dart';

class GetAllCompanies {
  final CompanyRepository repository;

  GetAllCompanies({required this.repository});

  Future<List<Company>> call({required String token}) async {
    return await repository.getAllCompanies(token: token);
  }
}