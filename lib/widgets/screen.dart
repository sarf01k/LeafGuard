import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Screen extends StatelessWidget {
  final Widget child;

  const Screen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: child,
    );
  }
}