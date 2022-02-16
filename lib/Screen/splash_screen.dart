import 'package:provider/provider.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:theme_looks/Screen/product_list_screen.dart';
import 'package:theme_looks/providers/firebase_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int counter = 0;
  customInit(FirebaseProvider firebaseProvider) async {
    counter++;
    await firebaseProvider.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseProvider firebaseProvider =
        Provider.of<FirebaseProvider>(context);
    if (counter == 0) {
      customInit(firebaseProvider);
    }
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SplashScreenView(
            navigateRoute: ProductListPage(
              context: context,
            ),
            duration: 5000,
            imageSize: 130,
            imageSrc: "assets/theme_looks.png",
            text: "Welcome To Theme looks",
            textType: TextType.ColorizeAnimationText,
            textStyle: const TextStyle(
              fontSize: 40.0,
            ),
            colors: const [
              Colors.purple,
              Colors.blue,
              Colors.yellow,
              Colors.red,
            ],
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
