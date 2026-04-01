import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const AgroScanApp());
}

class AgroScanApp extends StatelessWidget {
  const AgroScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroScan',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}