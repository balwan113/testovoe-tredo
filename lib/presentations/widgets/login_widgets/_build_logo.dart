import 'package:flutter/material.dart';

Widget buildLogo() {
  return Container(
    width: 120,
    height: 120,
    decoration: BoxDecoration(
      color: Colors.blue.shade100,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Icon(
        Icons.chat_bubble_outline,
        size: 60,
        color: Colors.blue.shade700,
      ),
    ),
  );
}
