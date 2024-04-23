import 'package:flutter/material.dart';
import 'package:knob_widget/knob_widget.dart';

class KnobWheel extends StatelessWidget {
  final KnobController controller;
  final double size;
  final KnobStyle style;
  final String label;

  const KnobWheel({
    super.key,
    required this.controller,
    required this.size,
    required this.style,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        Knob(
          controller: controller,
          height: size,
          width: size,
          style: style,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              label ,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).primaryColor
              , fontSize: MediaQuery.of(context).size.width * 0.02),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
