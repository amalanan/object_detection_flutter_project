import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import '../home/home.dart';

class MySplashPage extends StatefulWidget {
  const MySplashPage({super.key});

  @override
  State<MySplashPage> createState() => _MySplashPageState();
}

class _MySplashPageState extends State<MySplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      title: const Text('Object Detection App'),
      seconds: 4,
      imageBackground: Image.asset('assets/wall.jpeg').image,
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: const TextStyle(color: Colors.white),
      loadingText: const Text('Loading...'),
      loadingTextPadding: const EdgeInsets.all(16),
      useLoader: true,
      loaderColor: Colors.pink,
      navigateAfterSeconds: const MyHomePage(),
    );
  }
}
