import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/company.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/interfaces/datasources/icompany_datasource.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/infrastructure/models/company_model.dart';
import 'package:dio/dio.dart';

class CompanyDataSourceImpl implements CompanyDataSource {
  final Dio dio;
  final String baseUrl = 'https://chapatubusbackend.azurewebsites.net/api/v1';

  CompanyDataSourceImpl({required this.dio});

  @override
  Future<List<Company>> getAllCompanies({required String token}) async {
    try {
      final response = await dio.get(
        '$baseUrl/transport-company/all',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        return jsonData.map((json) => CompanyModel.fromJson(json).toEntity()).toList();
      } else {
        throw Exception('Failed to load companies');
      }
    } on DioException catch (e) {
      print('DioError: ${e.message}');
      throw Exception('${e.message}'); 
    } catch (e) {
      print('Error: $e');
      throw Exception('$e'); 
    }
  }
}