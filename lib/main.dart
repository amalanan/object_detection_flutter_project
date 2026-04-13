import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detecation_project/presentation/splash/splash.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Object Detection App',
      home: const MySplashPage(),
    );
  }
}
