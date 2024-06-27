import 'package:chapa_tu_bus_app/execution_monitoring/presentation/blocs/gps/gps_bloc.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/presentation/screens/gps_access_screen.dart';
import 'package:chapa_tu_bus_app/subscriptions/presentation/screens/subscription_check_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          return state.isAllGranted
              ? const SubscriptionCheckView()
              : const GpsAccessScreen();
        }, 
      ),
    );
  }
}