import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/bus.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/interfaces/repositories/ibus_repository.dart';

class GetBusesByCompanyId {
  final BusRepository repository;

  GetBusesByCompanyId({required this.repository});

  Future<List<Bus>> call({required String token, required int companyId}) async {
    return await repository.getBusesByUserId(
        token: token, companyId: companyId);
  }
}