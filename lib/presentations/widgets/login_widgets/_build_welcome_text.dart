import 'package:flutter/material.dart';

Widget buildWelcomeText() {
  return Column(
    children: const [
      Text(
        'Добро пожаловать в чат Flutter',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 16),
      Text(
        'Свяжитесь с друзьями и начните обмениваться сообщениями в режиме реального времени.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    ],
  );
}
