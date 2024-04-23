import 'package:flutter/material.dart';

class MyToggleSwitch extends StatefulWidget {
  final bool? isSwitched;
  final void Function(bool)? onChanged;


  const MyToggleSwitch({super.key, required this.isSwitched, required this.onChanged});

  @override
  _MyToggleSwitchState createState() => _MyToggleSwitchState();
}

class _MyToggleSwitchState extends State<MyToggleSwitch> {

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.isSwitched ?? false,
      onChanged: widget.onChanged,
      activeTrackColor: Colors.lightGreenAccent,
      activeColor: Colors.green,
    );
  }
}
