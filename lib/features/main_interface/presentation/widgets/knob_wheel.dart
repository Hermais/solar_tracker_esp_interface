import 'package:flutter/material.dart';
import 'package:knob_widget/knob_widget.dart';

class KnobWheel extends StatelessWidget {
  final KnobController? controller;
  final double? size;
  final KnobStyle? style;
  const KnobWheel({super.key, this.controller, this.size, this.style });

  @override
  Widget build(BuildContext context) {
    return Knob(
      controller: controller,
      height: size,
      width: size,
      style: style,
      

    );
  }
}
