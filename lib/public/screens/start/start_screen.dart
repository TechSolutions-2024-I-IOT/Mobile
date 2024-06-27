import 'package:chapa_tu_bus_app/account_management/presentation/widgets/auth/my_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class StartScreen extends StatelessWidget {
  
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // logo
                Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: const ShapeDecoration(
                        color: Color(0xFF556BDA),
                        shape: OvalBorder(),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.directions_bus,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
            
                const SizedBox(height: 50),
            
                // chapatubus
                const Text(
                  'ChapaTuBus',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            
                const SizedBox(height: 25),
            
                // move around the city easily
                const Text(
                  'Move around the city easily',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
            
                const SizedBox(height: 50),
            
            
                // start now button
                MyButton(
                  text: 'Start now',
                  onTap: () {
                    context.go('/auth');
                  }

                ),
            
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}