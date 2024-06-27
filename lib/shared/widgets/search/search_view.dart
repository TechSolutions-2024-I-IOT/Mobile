import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/bus_line.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/presentation/utils/bus_lines.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/presentation/widgets/bus_line/bus_line_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _searchController = TextEditingController();
  bool _hasSearchQuery = false;
  List<BusLine> _filteredBusLines = [];

  

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _hasSearchQuery = _searchController.text.isNotEmpty;
        _filterBusLines();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBusLines() {
    final searchText = _searchController.text.toLowerCase(); // Lowercase search text
    setState(() {
      _hasSearchQuery = searchText.isNotEmpty;
      _filteredBusLines = busLines.where((busLine) {
        return busLine.code.toLowerCase().contains(searchText) ||
            busLine.name.toLowerCase().contains(searchText);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Bus Line'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home/0');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              autofocus: true, 
              decoration: InputDecoration(
                hintText: 'Search for a bus line',
                hintStyle: const TextStyle(
                  color: Colors.black,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: 1.0,
                  ),
                ),
                filled: true,
                fillColor: const Color.fromARGB(
                    255, 249, 246, 246),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              _hasSearchQuery ? 'Results' : 'Recent searches',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount:_filteredBusLines.length,
                itemBuilder: (context, index) {
                  return BusLineCard(busLine: _filteredBusLines[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}