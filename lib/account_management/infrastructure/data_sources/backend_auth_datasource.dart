import 'package:chapa_tu_bus_app/account_management/domain/entities/user.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/data/local_database_datasource.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/data_sources/profile_datasource.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/models/authentication_response.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/models/login_request.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/models/register_request.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/models/backend/user_model_backend.dart';
import 'package:dio/dio.dart';

class BackendAuthDatasource {
  final String baseUrl =
      'https://chapatubusbackend.azurewebsites.net/api/v1/auth/';
  final Dio _dio = Dio();
  final LocalDatabaseDatasource _localDatabase =
      LocalDatabaseDatasource.instance;
  final ProfileDatasource _profileDatasource = ProfileDatasource();
  

  Future<String?> getToken() async {
    return await _localDatabase.getToken(); 
  }

  Future<Response> makeRequest(String endpoint, {Map<String, dynamic>? data, String? method}) async {
    final token = await getToken();
    if (token != null) {
      try {
        
        final response = await _dio.request(
          endpoint,
          data: data,
        );
        return response;
      } on DioException catch (e) {
        print('DioError: ${e.message}');
        if (e.response != null && e.response!.statusCode == 401) {
          // Token is invalid
          throw UnauthorizedException('Unauthorized');
        } else {
          rethrow;
        }
      } catch (e) {
        print('Error: $e');
        rethrow;
      }
    } else {
      throw UnauthorizedException('No token found');
    }
  }

  Future<AuthenticationResponse> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/login',
        data: LoginRequest(userEmail: email, userPassword: password).toJson(),
      );
      if (response.statusCode == 200) {
        final authResponse = AuthenticationResponse.fromJson(response.data);
        await _localDatabase.saveToken(authResponse.accessToken);
        final user = await _profileDatasource.getUserProfile(authResponse.userId);
        await _localDatabase
            .insertUser(UserModelBackend.fromJson(user.toJson()));
        return authResponse;
      } else {
        throw Exception('Authentication failed');
      }
    } on DioException catch (e) {
      // Handle Dio errors specifically
      print('DioError: ${e.message}');
      throw Exception('Authentication failed');
    } catch (e) {
      print('Error: $e');
      throw Exception('Authentication failed');
    }
  }

  Future<AuthenticationResponse> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String role,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await _dio.post(
        'https://chapatubusbackend.azurewebsites.net/api/v1/auth/register',
        data: RegisterRequest(
          email: email,
          password: password,
          role: role,
          firstName: firstName,
          lastName: lastName,
        ).toJson(),
      );
      print('Response: ${response.data}');
      if (response.statusCode == 201) {
        print('Response: ${response.data}');
        final authResponse = AuthenticationResponse.fromJson(response.data);
        await _localDatabase.saveToken(authResponse.accessToken);
        final user = await _profileDatasource.getUserProfile(authResponse.userId);
        await _localDatabase.insertUser(UserModelBackend.fromJson(user.toJson()));
        print('Response: ${response.data}');
        return authResponse;
      } else {
        throw Exception('Registration failed');
      }
    } on DioException catch (e) {
      print('DioError: ${e.message}');
      throw Exception('Registration failed');
    } catch (e) {
      print('Error: $e');
      throw Exception('Registration failed');
    }
  }


  Future<User?> getCurrentUser() async {
    final userId = await _localDatabase.getUserId();
    if (userId != null) {
      final user = await _localDatabase.getUserById(userId);
      if (user != null) {
        return User(
          id: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          photoURL: user.photoURL,
          role: user.role,
          password: user.password,
        );
      }
    }
    return null;
  }

  Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    String? photoUrl,
  }) async {
    final userId = await _localDatabase.getUserId();
    if (userId != null) {
      await _profileDatasource.updateUserProfile(
        userId: int.parse(userId),
        firstName: firstName,
        lastName: lastName,
        photoUrl: photoUrl,
      );
    }
  }

  Future<User?> getUserProfile() async {
    final userId = await _localDatabase.getUserId();
    if (userId != null) {
      // Pass userId as a positional argument
      final user = await _profileDatasource.getUserProfile(int.parse(userId));
      return user;
    } else {
      return null;
    }
  }

  Future<void> saveToken(String token) async {
    await _localDatabase.saveToken(token);
  }


}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);
}