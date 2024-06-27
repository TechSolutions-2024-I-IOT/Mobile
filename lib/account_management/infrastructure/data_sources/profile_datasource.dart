import 'package:chapa_tu_bus_app/account_management/domain/entities/user.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/data/local_database_datasource.dart';
import 'package:dio/dio.dart';

class ProfileDatasource {
  final String baseUrl = 'https://chapatubusbackend.azurewebsites.net/api/v1';
  final Dio _dio = Dio();

  ProfileDatasource() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
        final token = await LocalDatabaseDatasource.instance.getToken(); 
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options); 
      },
      onError: (DioException e, ErrorInterceptorHandler handler) {
        print('DioError: ${e.message}');
        if (e.response != null && e.response!.statusCode == 401) {
          // Token is invalid
          throw UnauthorizedException('Unauthorized');
        } else {
          throw e;
        }
      },
    ));
  }

  Future<User> getUserProfile(int userId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/users/user/profile',
        queryParameters: {'userId': userId},
      );
      print('Response: ${response.data}');
      if (response.statusCode == 200) {
        print('Response: ${response.data}');
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch user profile');
      }
    } on DioException catch (e) {
      print('DioError: ${e.message}');
      throw Exception('Failed to fetch user profile');
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch user profile');
    }
  }

  Future<void> updateUserProfile({
    required int userId,
    required String firstName,
    required String lastName,
    String? photoUrl,
  }) async {
    try {
      final response = await _dio.put(
        '$baseUrl/users/user/profile',
        queryParameters: {'userId': userId},
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'photoUrl': photoUrl,
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update user profile');
      }
    } on DioException catch (e) {
      print('DioError: ${e.message}');
      throw Exception('Failed to update user profile');
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to update user profile');
    }
  }
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);
}