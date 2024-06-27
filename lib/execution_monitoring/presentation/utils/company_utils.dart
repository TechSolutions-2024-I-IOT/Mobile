import 'package:chapa_tu_bus_app/execution_monitoring/api/transport_company_api.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/company.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/infrastructure/models/company_model.dart';

class CompanyUtils {
  static List<Company> companies = []; // Variable to store companies

  static Future<void> fetchCompanies(
      {required TransportCompanyApi api, required String token}) async {
    try {
      final jsonData = await api.getAllCompanies(token: token);
      companies = jsonData.map((json) => CompanyModel.fromJson(json).toEntity()).toList();
    } catch (e) {
      // Handle errors 
      print('Error fetching companies: $e'); 
    }
  }
}