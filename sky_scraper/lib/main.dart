import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';

void main() {
  runApp(MaterialApp(
    title: 'Sky Scanner',
    home: HomeRoute(),
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      )
  ));
}

