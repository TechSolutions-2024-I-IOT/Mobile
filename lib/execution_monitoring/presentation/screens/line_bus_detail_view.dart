import 'package:cached_network_image/cached_network_image.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/presentation/screens/map_screen.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/presentation/utils/bus_lines.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LineBusDetailView extends StatefulWidget {
  static const name = 'LineBusDetail';
  static String getViewName() => name;
  final int lineId;
  const LineBusDetailView({super.key, required this.lineId});

  @override
  State<LineBusDetailView> createState() => _LineBusDetailViewState();
}

class _LineBusDetailViewState extends State<LineBusDetailView> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    final busLine = busLines.firstWhere((line) => line.id == widget.lineId);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home/0'),
        ),
        title: Text(busLine.code),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: busLine.imagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          busLine.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(busLine.code),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const MapScreen(),
              const SizedBox(height: 16),
              const Text('Stop bus: Plaza Norte',
                  style: TextStyle(fontSize: 16)),
              const Text('Time arrived: 4 minutos',
                  style: TextStyle(fontSize: 16)),
              const Text('Capacity: 15/30 (50%)', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      //TODO: Acción para ver próximos buses
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 116, 153, 182),
                    ),
                    child: const Text('See next buses'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      backgroundColor:
                          isFavorite ? Colors.yellow : Colors.white,
                      padding: EdgeInsets.zero,
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Icon(
                      isFavorite ? Icons.star_outline : Icons.star_border,
                      color: isFavorite ? Colors.black : Colors.black,
                      size: 24, // Adjust icon size as needed
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
