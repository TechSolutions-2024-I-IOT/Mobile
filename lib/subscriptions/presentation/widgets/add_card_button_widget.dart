import 'package:flutter/material.dart';

class AddCardButtonWidget extends StatelessWidget {
  const AddCardButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: const Color(0xff1b447b),
      ),
      child: Container(
        margin: const EdgeInsets.all(12),
        child: const Text(
          'Añadir tarjeta',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'halter',
            fontSize: 14,
            package: 'flutter_credit_card',
          ),
        ),
      ),
      onPressed: () {
        if (formKey.currentState!.validate()) {
          // Handle card addition logic here
          print('Card Added!');
        } else {
          print('Invalid form data');
        }
      },
    );
  }
}