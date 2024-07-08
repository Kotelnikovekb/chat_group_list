import 'package:flutter/material.dart';

class DateSeparator extends StatelessWidget {
  final DateTime date;

  const DateSeparator({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.grey[300],
      child: Text(
        '${date.day}-${date.month}-${date.year}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
