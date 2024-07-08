import 'package:flutter/material.dart';

class DateHeader extends StatelessWidget {
  final DateTime date;

  const DateHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          date.toString(),
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }
}