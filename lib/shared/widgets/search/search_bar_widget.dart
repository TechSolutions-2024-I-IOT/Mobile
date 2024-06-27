import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onTap: () {
          context.go('/home/0/search');
        },
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
              255, 249, 246, 246), // Light grey background
        ),
      ),
    );
  }
}



