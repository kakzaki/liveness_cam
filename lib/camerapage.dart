import 'dart:io';

import 'package:flutter/material.dart';
import 'package:liveness_cam/src/smart_face_camera.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(''),
        ),
        body: Builder(builder: (context) {
          return SmartFaceCamera(
              onCapture: (File? image) {
                Navigator.of(context).pop(image);
              },
              messageBuilder: (context, face) {
                if (face == null) {
                  return _message('Tempatkan wajah anda pada kamera');
                }
                if (!face.wellPositioned) {
                  return _message('Pastikan wajah anda di dalam kotak');
                }
                return const SizedBox.shrink();
              });
        }));
  }

  Widget _message(String msg) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
    child: Text(msg,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 14, height: 1.5, fontWeight: FontWeight.w400)),
  );

}
