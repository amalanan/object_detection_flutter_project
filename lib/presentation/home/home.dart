// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:object_detecation_project/main.dart';
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   bool isWorking = false;
//   String result = "";
//   CameraController cameraController;
//   CameraImage imgCamera;
//
//   initCamera(){
//     cameraController = CameraController(cameras[0], ResolutionPreset.medium);
//     cameraController.initialize().then((value){
//       if(!mounted){
//        return;
//       }
//       setState(() {
//         cameraController.startImageStream((imageFromStream) =>{
//           if(!isWorking){
//             isWorking = true,
//             imgCamera = imageFromStream,
//           }
//         });
//
//       });
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detecation_project/main.dart';

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
    initCamera();
  }

  initCamera() {
    cameraController =
        CameraController(cameras![0], ResolutionPreset.medium);

    cameraController.initialize().then((value) {
      if (!mounted) return;

      cameraController.startImageStream((imageFromStream) {
        if (!isWorking) {
          isWorking = true;
          imgCamera = imageFromStream;

          // هون لاحقاً بتحط inference (deep learning)
        }
      });

      setState(() {});
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: CameraPreview(cameraController),
    );
  }
}