import 'package:flutter/material.dart';

class Overlayloading extends StatelessWidget {
  const Overlayloading({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (value) {
          if (value) {}
        },
        child: const Center(
          child: CircularProgressIndicator(),
        ));
  }
}
