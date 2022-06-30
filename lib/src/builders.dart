import 'package:flutter/material.dart';
import 'scanned_image.dart';


/// Returns message based on face position
typedef MessageBuilder = Widget Function(
    BuildContext context, DetectedFace? detectedFace);
