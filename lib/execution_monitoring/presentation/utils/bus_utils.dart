import 'package:chapa_tu_bus_app/execution_monitoring/api/transport_company_api.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/bus.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/infrastructure/models/bus_model.dart';

class BusUtils {
  static List<Bus> buses = []; // Variable to store fetched buses

  static Future<void> fetchBuses(
      {required TransportCompanyApi api, required String token, required int userId}) async {
    try {
      final jsonData = await api.getBusesByUserId(token: token, userId: userId);
      buses = jsonData.map((json) => BusModel.fromJson(json).toEntity()).toList();
    } catch (e) {
      // Handle errors (e.g., print error, show a message, etc.)
      print('Error fetching buses: $e'); 
    }
  }
}