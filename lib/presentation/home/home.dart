// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:object_detecation_project/main.dart';
// import 'package:tflite/tflite.dart';
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
//
//   late CameraController cameraController;
//   CameraImage? imgCamera;
//
//   @override
//   void initState() {
//     super.initState();
//     loadModel();
//     initCamera();
//   }
//
//   loadModel() async {
//     await Tflite.loadModel(
//       model: 'assets/mobilenet_v1_1.0_224.tflite',
//       labels: 'assets/mobilenet_v1_1.0_224.txt',
//     );
//   }
//
//   initCamera() {
//     if (cameras == null || cameras!.isEmpty) return;
//     cameraController = CameraController(cameras![0], ResolutionPreset.medium);
//     cameraController.initialize().then((value) {
//       if (!mounted) return;
//
//       cameraController.startImageStream((imageFromStream) {
//         if (!isWorking) {
//           isWorking = true;
//           imgCamera = imageFromStream;
//           runModelOnStreamFrames();
//         }
//       });
//       setState(() {});
//     });
//   }
//
//   runModelOnStreamFrames() async {
//     await Future.delayed(Duration(milliseconds: 300));
//     if (imgCamera != null) {
//       var recognitions = await Tflite.runModelOnFrame(
//         bytesList:
//             imgCamera!.planes.map((plane) {
//               return plane.bytes;
//             }).toList(),
//         imageHeight: imgCamera!.height,
//         imageWidth: imgCamera!.width,
//         imageMean: 127.5,
//         imageStd: 127.5,
//         rotation: 90,
//         numResults: 2,
//         threshold: 0.1,
//         asynch: true,
//       );
//       result = "";
//       recognitions?.forEach((response) {
//         result +=
//             response["label"] +
//             " " +
//             (response["confidence"] as double).toStringAsFixed(2) +
//             "\n\n";
//       });
//       setState(() {
//         result;
//       });
//       isWorking = false;
//     }
//   }
//
//   @override
//   void dispose() async {
//     await Tflite.close();
//     cameraController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!mounted || !cameraController.value.isInitialized) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//     return Scaffold(
//       appBar: AppBar(title: Text("Object Detection")),
//       body: Column(
//         children: [
//           AspectRatio(
//             aspectRatio: cameraController.value.aspectRatio,
//             child: CameraPreview(cameraController),
//           ),
//           SizedBox(height: 20),
//           Text(
//             result,
//             style: TextStyle(fontSize: 18),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   // return MaterialApp(
//   //   home: SafeArea(child:
//   //   Scaffold(
//   //     body: Container(
//   //       decoration: BoxDecoration(
//   //         image: DecorationImage(image: AssetImage('assets/app.jpeg')
//   //         )),
//   //       child: Column(
//   //         children: [Stack(
//   //           children: [
//   //             Center(
//   //               child: Container(
//   //                 color:Colors.black,
//   //                 height: 320,
//   //                 width: 360,
//   //                 child: Image.asset('assets/butterfly.jpeg'),
//   //               ),
//   //             ),
//   //             Center(
//   //               child: FloatingActionButton(onPressed: (){
//   //                 initCamera();
//   //               },
//   //               child: Container(
//   //                 margin: EdgeInsets.only(top: 35),
//   //                 height: 270,
//   //                 width: 360,
//   //                 child: imgCamera == null? Container(
//   //                   height: 270,
//   //                 ),
//   //               ),
//   //               ),
//   //             )
//   //           ],
//   //         )],
//   //       ),
//   //     ),
//   //   )
//   //   ),
//   // );
//   // if (!cameraController.value.isInitialized) {
//   //   return const Center(child: CircularProgressIndicator());
//   // }
//   //
//   // return Scaffold(body: CameraPreview(cameraController));
// }

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
  bool isCameraInitialized = false;

  String result = "";

  CameraController? cameraController;
  CameraImage? imgCamera;

  @override
  void initState() {
    super.initState();
    loadModel();
    initCamera();
  }

  // ✅ Load model safely
  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/mobilenet_v1_1.0_224.tflite',
      labels: 'assets/mobilenet_v1_1.0_224.txt',
    );
  }

  // ✅ Initialize camera safely
  initCamera() {
    if (cameras == null || cameras!.isEmpty) return;

    cameraController =
        CameraController(cameras![0], ResolutionPreset.medium);

    cameraController!.initialize().then((value) {
      if (!mounted) return;

      isCameraInitialized = true;

      cameraController!.startImageStream((imageFromStream) {
        if (!isWorking) {
          isWorking = true;
          imgCamera = imageFromStream;
          runModelOnStreamFrames();
        }
      });

      setState(() {});
    });
  }

  // ✅ Run model with delay (performance safe)
  runModelOnStreamFrames() async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (imgCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera!.planes.map((plane) => plane.bytes).toList(),
        imageHeight: imgCamera!.height,
        imageWidth: imgCamera!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );

      result = "";

      recognitions?.forEach((response) {
        result +=
        "${response["label"]} ${(response["confidence"] as double)
            .toStringAsFixed(2)}\n\n";
      });

      if (mounted) {
        setState(() {});
      }

      isWorking = false;
    }
  }

  @override
  void dispose() {
    Tflite.close();
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Safe loading state
    if (!isCameraInitialized || cameraController == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Object Detection")),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: cameraController!.value.aspectRatio,
            child: CameraPreview(cameraController!),
          ),

          const SizedBox(height: 20),

          // ✅ Prevent overflow
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                result,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}