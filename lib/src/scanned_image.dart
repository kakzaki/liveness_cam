import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class DetectedFace {
  final Face face;
  final bool wellPositioned;
  final bool isBlinking;
  final bool isSmiling;
  final bool isMouthOpen;
  const DetectedFace({required this.face, required this.wellPositioned,required this.isBlinking,required this.isSmiling, required this.isMouthOpen});

  DetectedFace copyWith({Face? face, bool? wellPositioned, bool? isBlinking, bool? isSmiling, bool? isMouthOpen}) => DetectedFace(
      face: face ?? this.face,
      wellPositioned: wellPositioned ?? this.wellPositioned,
      isBlinking: isBlinking?? this.isBlinking,
      isSmiling: isSmiling?? this.isSmiling,
      isMouthOpen: isMouthOpen?? this.isMouthOpen
  );
}
