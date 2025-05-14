import 'package:flutter/material.dart';

class CustomInkWell extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const CustomInkWell({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // borderRadius: BorderRadius.circular(10),
      splashFactory: NoSplash.splashFactory, // Tidak ada efek ripple
      highlightColor: Colors.transparent, // Tidak ada warna highlight saat ditekan
      onTap: onTap,
      child: child,
    );
  }
}
