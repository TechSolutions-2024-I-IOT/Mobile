import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/company.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/interfaces/datasources/icompany_datasource.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/interfaces/repositories/icompany_repository.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyDataSource companyDataSource;

  CompanyRepositoryImpl({required this.companyDataSource});

  @override
  Future<List<Company>> getAllCompanies({required String token}) async {
    return await companyDataSource.getAllCompanies(token: token);
  }
}
