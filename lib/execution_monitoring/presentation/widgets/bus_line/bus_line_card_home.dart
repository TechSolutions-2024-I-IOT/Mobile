import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/bus_line.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BusLineCardHome extends StatelessWidget {
  final BusLine busLine;

  const BusLineCardHome({super.key, required this.busLine});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/home/1/line/${busLine.id}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
          color: Colors.white,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(busLine.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        busLine.code,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: busLine.name,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
