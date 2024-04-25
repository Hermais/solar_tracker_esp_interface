import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  final String? message;
  const Splash({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Image(image: AssetImage('assets/images/DUA_AXIS.jpg')),
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(message ?? "", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ,)
            ],
          ),
        ),

      ),
    );
  }
}
