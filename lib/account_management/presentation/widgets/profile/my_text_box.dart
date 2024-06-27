import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String? text;
  final String sectionName;
  final IconData icon;
  const MyTextBox(
      {super.key,
      required this.text,
      required this.sectionName,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black, size: 24),
              const SizedBox(width: 10),
              Text(sectionName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 5),
              Text(text ?? '', style: const TextStyle(fontSize: 16)),
            
            ],
          ),
        ],
      ),
    );
  }
}
