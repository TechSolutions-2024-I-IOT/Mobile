import 'package:flutter/material.dart';

class FavoritesView extends StatelessWidget {
  static const name = 'Favorites lines';
  static String getViewName() => name;
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60.0), // Espacio para el botón
            child: ListView.builder(
              itemCount: favoriteBusLines.length,
              itemBuilder: (context, index) {
                return FavoriteBusLineCard(busLine: favoriteBusLines[index]);
              },
            ),
          ),
          Positioned(
            top: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Agrega aquí la lógica para "Editar"
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Edit'),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteBusLine {
  final String code;
  final String name;
  final String imagePath;

  FavoriteBusLine({
    required this.code,
    required this.name,
    required this.imagePath,
  });
}

final List<FavoriteBusLine> favoriteBusLines = [
  FavoriteBusLine(
    code: '[209]',
    name: 'Ate - San Miguel\nCorredor Rojo',
    imagePath: 'https://upload.wikimedia.org/wikipedia/commons/5/59/Linea_7_-_Lima.jpg',
  ),
  FavoriteBusLine(
    code: '[CR71]',
    name: 'Ate - San Martin de\nPorres',
    imagePath: 'https://upload.wikimedia.org/wikipedia/commons/5/59/Linea_7_-_Lima.jpg',
  ),
  FavoriteBusLine(
    code: '[CR07]',
    name: 'Callao -\nLa Perla',
    imagePath: 'https://upload.wikimedia.org/wikipedia/commons/5/59/Linea_7_-_Lima.jpg',
  ),
];

class FavoriteBusLineCard extends StatelessWidget {
  final FavoriteBusLine busLine;

  const FavoriteBusLineCard({super.key, required this.busLine});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                children: <Widget>[
                  Text(
                    busLine.code,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(busLine.name),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}