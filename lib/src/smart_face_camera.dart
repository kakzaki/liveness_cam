import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'face_identifier.dart';
import 'scanned_image.dart';
import 'face_painter.dart';
import 'builders.dart';



class SmartFaceCamera extends StatefulWidget {
  final String? message;
  final TextStyle messageStyle;
  final void Function(File? image) onCapture;
  final MessageBuilder? messageBuilder;

  const SmartFaceCamera(
      {this.message,
      this.messageStyle = const TextStyle(
          fontSize: 14, height: 1.5, fontWeight: FontWeight.w400),
      required this.onCapture,
      this.messageBuilder,
      Key? key})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SmartFaceCameraState createState() => _SmartFaceCameraState();
}

class _SmartFaceCameraState extends State<SmartFaceCamera>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? _controller;

  bool _alreadyCheckingImage = false;

  DetectedFace? _detectedFace;


  Future<void> _initCamera() async {
    List<CameraDescription> cameras= await availableCameras();
    cameras=cameras.where((element) => element.lensDirection==CameraLensDirection.front).toList();
    if (cameras.isNotEmpty) {
      _controller = CameraController(cameras.first,
          ResolutionPreset.medium,
          enableAudio: true,
          imageFormatGroup: ImageFormatGroup.jpeg);

      await _controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
    _startImageStream();
  }



  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final CameraController? cameraController = _controller;
    if (cameraController != null && cameraController.value.isInitialized) {
      cameraController.dispose();
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.stopImageStream();
    } else if (state == AppLifecycleState.resumed) {
      _startImageStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final CameraController? cameraController = _controller;
    return Stack(
      alignment: Alignment.center,
      children: [
        if (cameraController != null && cameraController.value.isInitialized) ...[
          Transform.scale(
            scale: 1.0,
            child: AspectRatio(
              aspectRatio: size.aspectRatio,
              child: OverflowBox(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: SizedBox(
                    width: size.width,
                    height: size.width * cameraController.value.aspectRatio,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        _cameraDisplayWidget(),
                        if (_detectedFace != null) ...[
                          SizedBox(
                              width: cameraController.value.previewSize!.width,
                              height:
                                  cameraController.value.previewSize!.height,
                              child: CustomPaint(
                                painter: FacePainter(
                                    face: _detectedFace!.face,
                                    imageSize: Size(
                                      _controller!.value.previewSize!.height,
                                      _controller!.value.previewSize!.width,
                                    )),
                              ))
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ] else ...[
          const Text('No Camera Detected',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              )),
        ],
      ],
    );
  }

  /// Render camera.
  Widget _cameraDisplayWidget() {
    final CameraController? cameraController = _controller;
    if (cameraController != null && cameraController.value.isInitialized) {
      return CameraPreview(cameraController, child: Builder(builder: (context) {
        if (widget.messageBuilder != null) {
          return widget.messageBuilder!.call(context, _detectedFace);
        }
        if (widget.message != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
            child: Text(widget.message!,
                textAlign: TextAlign.center, style: widget.messageStyle),
          );
        }
        return const SizedBox.shrink();
      }));
    }
    return const SizedBox.shrink();
  }


  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (_controller == null) {
      return;
    }

    final CameraController cameraController = _controller!;

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  void _onTakePictureButtonPressed() async {
    final CameraController? cameraController = _controller;
    try {
      cameraController!.stopImageStream().whenComplete(() async {
        await Future.delayed(const Duration(milliseconds: 500));
        takePicture().then((XFile? file) {
          /// Return image callback
          widget.onCapture(File(file!.path));

          /// Resume image stream after 2 seconds of capture

          Future.delayed(const Duration(seconds: 2)).whenComplete(() {
            if (mounted && cameraController.value.isInitialized) {
              try {
                _startImageStream();
              } catch (e) {
                debugPrint(e.toString());
              }
            }
          });
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void _startImageStream() {
    final CameraController? cameraController = _controller;
    if (cameraController != null) {
      cameraController.startImageStream(_processImage);
    }
  }

  void _processImage(CameraImage cameraImage) async {
    final CameraController? cameraController = _controller;
    if (!_alreadyCheckingImage && mounted) {
      _alreadyCheckingImage = true;
      try {
        await FaceIdentifier.scanImage(
                cameraImage: cameraImage, camera: cameraController!.description)
            .then((result) async {
          setState(() => _detectedFace = result);

          if (result != null) {
            try {
              if (result.wellPositioned) {
                _onTakePictureButtonPressed();
              }
            } catch (e) {
              debugPrint(e.toString());
            }
          }
        });
        _alreadyCheckingImage = false;
      } catch (ex, stack) {
        debugPrint('$ex, $stack');
      }
    }
  }
}
