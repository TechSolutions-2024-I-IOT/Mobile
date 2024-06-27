import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/bus.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/interfaces/datasources/ibus_datasource.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/interfaces/repositories/ibus_repository.dart';

class BusRepositoryImpl implements BusRepository {
  final BusDataSource busDataSource;

  BusRepositoryImpl({required this.busDataSource});

  @override
  Future<List<Bus>> getBusesByUserId(
      {required String token, required int companyId}) async {
    return await busDataSource.getBusesByCompanyId(
        token: token, companyId: companyId);
  }
}