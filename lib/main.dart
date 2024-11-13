import 'package:bukutamu/feature/view/home_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(bukutamu());
}

class bukutamu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buku Tamu',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GuestBookHomePage(),
    );
  }
}
