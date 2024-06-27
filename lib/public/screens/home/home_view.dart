import 'package:chapa_tu_bus_app/execution_monitoring/presentation/utils/bus_lines.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/presentation/widgets/bus_line/bus_line_card_home.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/presentation/widgets/bus_line/bus_line_frecuents.dart';
import 'package:chapa_tu_bus_app/shared/widgets/search/search_bar_widget.dart';
import 'package:chapa_tu_bus_app/subscriptions/presentation/widgets/box_subscription.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  static const name = 'Home';
  static String getViewName() => name;
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SearchBarWidget(),
          const BoxSubscription(),
          const SizedBox(height: 16.0),
          const BusLinesFrecuents(),
          Expanded(
            child: ListView.builder(
              itemCount: busLines.length,
              itemBuilder: (context, index) {
                return BusLineCardHome(busLine: busLines[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

