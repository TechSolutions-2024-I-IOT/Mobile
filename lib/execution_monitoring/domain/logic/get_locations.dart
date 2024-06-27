import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/location.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/interfaces/repositories/ilocation_repository.dart';

class GetLocations {
  final LocationRepository repository;

  GetLocations({required this.repository});

  Future<List<Location>> call({required String token}) async {
    return await repository.getLocations(token: token);
  }
}