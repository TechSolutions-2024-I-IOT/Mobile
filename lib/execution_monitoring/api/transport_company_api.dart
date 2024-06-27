import 'package:dio/dio.dart';

class TransportCompanyApi {
  final Dio dio;
  final String baseUrl = 'https://chapatubusbackend.azurewebsites.net/api/v1';

  TransportCompanyApi({required this.dio});

  Future<List<dynamic>> getLocations({required String token}) async {
    return await _makeGetRequest(endpoint: '/location-data', token: token);
  }

  Future<List<dynamic>> getBusesByUserId(
      {required String token, required int userId}) async {
    return await _makeGetRequest(
        endpoint: '/transport-company/buses?userId=$userId', token: token);
  }

  Future<List<dynamic>> getAllCompanies({required String token}) async {
    return await _makeGetRequest(endpoint: '/transport-company/all', token: token);
  }

  Future<List<dynamic>> _makeGetRequest(
      {required String endpoint, required String token}) async {
    try {
      final response = await dio.get(
        '$baseUrl$endpoint', 
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors (e.g., network issues)
      print('Dio Error: ${e.message}'); 
      throw Exception('${e.message}'); // Or throw a more specific Dio-related exception
    } catch (e) {
      print('API Error: $e'); 
      throw Exception('$e'); 
    }
  }
}
