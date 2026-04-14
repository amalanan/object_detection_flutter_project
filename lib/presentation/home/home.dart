import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detecation_project/main.dart';
import 'package:tflite/tflite.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isWorking = false;
  String result = "";

  late CameraController cameraController;
  CameraImage? imgCamera;

  @override
  void initState() {
    super.initState();
    loadModel();
    initCamera();
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'mobilenet_v1_1.0_224.tflite',
      labels: 'mobilenet_v1_1.0_224.txt',
    );
  }

  initCamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);

    cameraController.initialize().then((value) {
      if (!mounted) return;

      cameraController.startImageStream((imageFromStream) {
        if (!isWorking) {
          isWorking = true;
          imgCamera = imageFromStream;
        }
      });
      setState(() {});
    });
  }

  @override
  void dispose() async {
    await Tflite.close();
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(body: CameraPreview(cameraController));
  }
}
