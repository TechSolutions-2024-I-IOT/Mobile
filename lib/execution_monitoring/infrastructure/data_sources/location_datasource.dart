import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/location.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/interfaces/datasources/ilocation_datasource.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/infrastructure/models/location_model.dart';
import 'package:dio/dio.dart';

class LocationDataSourceImpl implements LocationDataSource {
  final Dio dio;
  final String baseUrl = 'https://chapatubusbackend.azurewebsites.net/api/v1';

  LocationDataSourceImpl({required this.dio});

  @override
  Future<List<Location>> getLocations({required String token}) async {
    try {
      final response = await dio.get(
        '$baseUrl/location-data',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        // Convert LocationModel to Location:
        return jsonData
            .map((json) => LocationModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw Exception('Failed to load locations');
      }
    } on DioException catch (e) {
      print('DioError: ${e.message}');
      throw Exception('${e.message}');
    } catch (e) {
      print('Error: $e');
      throw Exception(e.toString());
    }
  }
}