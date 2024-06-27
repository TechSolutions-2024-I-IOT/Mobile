import 'package:chapa_tu_bus_app/account_management/infrastructure/data/local_database_datasource.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/api/transport_company_api.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/bus.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/company.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/logic/get_all_companies.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/logic/get_buses_by_user_id.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/infrastructure/data_sources/bus_datasource.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/infrastructure/data_sources/company_datasource.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/infrastructure/repositories/bus_repository_impl.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/infrastructure/repositories/company_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LineBusesView extends StatefulWidget {
  static const name = 'Line of buses';
  static String getViewName() => name;
  const LineBusesView({super.key});

  @override
  LineBusesViewState createState() => LineBusesViewState();
}

class LineBusesViewState extends State<LineBusesView> {
  int _selectedIndex = 0;
  List<Company> _companies = [];
  List<Bus> _buses = [];

  @override
  void initState() {
    super.initState();
    _fetchCompaniesAndBuses();
  }

  Future<void> _fetchCompaniesAndBuses() async {
    final api = Provider.of<TransportCompanyApi>(context, listen: false);
    final token = await LocalDatabaseDatasource.instance.getToken(); // Get token from local database

    if (token != null) {
      final companyUseCase = GetAllCompanies(
          repository: CompanyRepositoryImpl(
              companyDataSource: CompanyDataSourceImpl(dio: api.dio)));
      final busUseCase = GetBusesByCompanyId(
          repository: BusRepositoryImpl(
              busDataSource: BusDataSourceImpl(dio: api.dio)));

      try {
        final companiesResponse = await companyUseCase.call(token: token);
        setState(() {
          _companies = companiesResponse;
        });

        // Fetch buses for the first company initially
        if (_companies.isNotEmpty) {
          final companyId = _companies[0].id;
          final busesResponse = await busUseCase.call(
            token: token,
            companyId: companyId,
          );
          setState(() {
            _buses = busesResponse;
          });
        }
      } catch (e) {
        print('Error fetching data: $e');
        // Handle errors appropriately (show a message, retry, etc.)
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // Filter buttons (you can implement filtering logic here)
                for (int i = 0; i < _companies.length; i++)
                  _buildFilterButton(
                    _companies[i].name,
                    i,
                  ),
              ],
            ),
          ),
        ),
        // Display the selected company
        if (_selectedIndex < _companies.length)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: _selectedIndex == 0 ? Colors.blue[300] : Colors.purple[300],
            child: Row(
              children: <Widget>[
                Text(
                  _companies[_selectedIndex].name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView(
            children: <Widget>[
              // Display buses of the selected company
              for (final bus in _buses)
                _buildBusLineTile(bus.licensePlate, bus.state),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String text, int index) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _selectedIndex = index;
        });

        final api = Provider.of<TransportCompanyApi>(context, listen: false);
        final token = await LocalDatabaseDatasource.instance.getToken(); // Get token from local database

        final busUseCase = GetBusesByCompanyId(
            repository: BusRepositoryImpl(
                busDataSource: BusDataSourceImpl(dio: api.dio)));

        try {
          final companyId = _companies[index].id; 
          final busesResponse = await busUseCase.call(
            token: token ?? '',
            companyId: companyId, 
          );
          setState(() {
            _buses = busesResponse;
          });
        } catch (e) {
          print('Error fetching buses: $e');
          // Handle errors appropriately (show a message, retry, etc.)
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedIndex == index ? Colors.blue[300] : Colors.grey[300],
        foregroundColor: _selectedIndex == index ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      ),
      child: Text(
        text,
      ),
    );
  }

  Widget _buildBusLineTile(String code, String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: <Widget>[
          Text(
            code,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8.0),
          Text(name),
        ],
      ),
    );
  }
}