import 'package:flutter/material.dart';

class BusLinesFrecuents extends StatelessWidget {
  const BusLinesFrecuents({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          'Líneas frecuentes',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}