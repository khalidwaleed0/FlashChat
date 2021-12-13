import 'package:flutter/material.dart';

class ConditionWidget extends StatelessWidget {
  ConditionWidget(this.title, this.isValid);
  final String title;
  final bool isValid;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isValid ? Icon(Icons.check, color: Colors.green) : Icon(Icons.clear, color: Colors.red),
        Text(title),
      ],
    );
  }
}
