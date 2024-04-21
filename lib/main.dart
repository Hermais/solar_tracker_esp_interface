
import 'package:flutter/material.dart';

import 'features/main_interface/presentation/screens/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Knob Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const Dashboard(title: 'Flutter Knob Demo'),
    );
  }
}

