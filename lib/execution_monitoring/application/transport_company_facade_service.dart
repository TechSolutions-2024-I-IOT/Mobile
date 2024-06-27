import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/bus.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/company.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/location.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/logic/get_all_companies.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/logic/get_buses_by_user_id.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/logic/get_locations.dart';

class TransportCompanyFacadeService {
  final GetLocations getLocations;
  final GetBusesByCompanyId getBusesByUserId;
  final GetAllCompanies getAllCompanies;

  TransportCompanyFacadeService({
    required this.getLocations,
    required this.getBusesByUserId,
    required this.getAllCompanies,
  });

  // Fetch Locations with Error Handling
  Future<List<Location>?> fetchLocations(String token) async {
    try {
      final locations = await getLocations.call(token: token);
      return locations;
    } catch (e) {
      print('Error fetching locations: $e');
      return null; // Or rethrow the exception:  'rethrow;' 
    }
  }

  // Fetch Buses by User ID with Error Handling
  Future<List<Bus>?> fetchBusesByUserId(String token, int userId) async {
    try {
      final buses = await getBusesByUserId.call(
        token: token, 
        companyId: userId
      );
      return buses;
    } catch (e) {
      print('Error fetching buses by user ID: $e');
      return null; // Or rethrow: 'rethrow;'
    }
  }

  // Fetch All Companies with Error Handling
  Future<List<Company>?> fetchAllCompanies(String token) async {
    try {
      final companies = await getAllCompanies.call(token: token);
      return companies;
    } catch (e) {
      print('Error fetching all companies: $e');
      return null; // Or rethrow: 'rethrow;'
    }
  }
}