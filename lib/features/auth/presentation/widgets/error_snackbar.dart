import 'package:flutter/material.dart';

class ErrorSnackBar extends StatelessWidget {
  final String message;

  const ErrorSnackBar({required this.message});

  @override
  Widget build(BuildContext context) {
    return SnackBar(content: Text(message), backgroundColor: Colors.red);
  }
}
