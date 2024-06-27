import 'package:chapa_tu_bus_app/account_management/infrastructure/data/local_database_datasource.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/presentation/blocs/location/location_bloc.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/presentation/views/map_view.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/presentation/widgets/map/btn_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;

  @override
  void initState() {
    super.initState();

    locationBloc = BlocProvider.of<LocationBloc>(context);
    _fetchInitialLocation(); 
    locationBloc.startFollowingUser();
  }

  Future<void> _fetchInitialLocation() async {
    final token = await LocalDatabaseDatasource.instance.getToken();

    if (token != null) {
      locationBloc.add(FetchInitialLocationEvent(token: token));
    }
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        
        if (state.initialLocation != null) {
          print(' Initial location ${state.initialLocation!}');
          return SizedBox(
            height: 250,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Stack(
                  children: [
                    MapView(initialLocation: state.initialLocation!), 
                    // TODO: buttons
                  ],
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BtnCurrentLocation(),
                ],
              ),
            ),
          );
          
        } else {
          return const Center(child: Text('Wait a moment please...'));
        }
      },
    );
  }
}