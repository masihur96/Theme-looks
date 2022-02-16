import 'package:flutter/material.dart';
import 'package:theme_looks/functions/custom_size.dart';

BuildContext? context;
const kPrimaryColor = Color(0xFF0861AF); //(0xFF19B52B);
const kPrimaryLightColor = Color(0xFF19B56B);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF0861AF), Color(0xFF19B52B), Color(0xFF0198DD)],
);

final headingStyle = TextStyle(
  fontSize: screenSize(context!, 28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);
