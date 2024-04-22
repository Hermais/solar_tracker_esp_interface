import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image(image: AssetImage('assets/images/DUA_AXIS.jpg')),
              CircularProgressIndicator(),
            ],
          ),
        ),

      ),
    );
  }
}
