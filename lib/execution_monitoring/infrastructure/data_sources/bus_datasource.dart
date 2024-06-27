import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/bus.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/interfaces/datasources/ibus_datasource.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/infrastructure/models/bus_model.dart';
import 'package:dio/dio.dart';

class BusDataSourceImpl implements BusDataSource {
  final Dio dio;
  final String baseUrl = 'https://chapatubusbackend.azurewebsites.net/api/v1';

  BusDataSourceImpl({required this.dio});

  @override
  Future<List<Bus>> getBusesByCompanyId(
      {required String token, required int companyId}) async {
    try {
      final response = await dio.get(
        '$baseUrl/transport-company/buses?userId=$companyId', 
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        return jsonData.map((json) => BusModel.fromJson(json).toEntity()).toList();
      } else {

        throw Exception('Failed to load buses');
      }
    } on DioException catch (e) {
      print('DioError: ${e.message}');
      throw Exception('${e.message}'); // Or throw a more specific Dio-related exception
    } catch (e) {
      print('Error: $e');
      throw Exception('$e'); // Generic catch-all
    }
  }
}