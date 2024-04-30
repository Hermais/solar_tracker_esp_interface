import 'package:flutter/material.dart';

class SafeIcon extends StatelessWidget {
  final IconData icon;
  final IconData fallbackIcon;
  final double size;
  final Color color;

  const SafeIcon({
    super.key,
    required this.icon,
    this.fallbackIcon = Icons.error_outline,
    this.size = 24.0,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    try {
      // Attempt to load the desired icon
      return Icon(icon, size: size, color: color);
    } catch (e) {
      // If an error occurs, use the fallback icon
      return Icon(fallbackIcon, size: size, color: color);
    }
  }
}
