import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learning_pose_detection/learning_pose_detection.dart';
import 'package:learning_input_image/learning_input_image.dart';

enum DetectedPose {
  standing,
  sitting,
}

class PoseDetectionPage extends StatefulWidget {
  @override
  _PoseDetectionPageState createState() => _PoseDetectionPageState();
}

class _PoseDetectionPageState extends State<PoseDetectionPage> {
  PoseDetectionState get state => Provider.of(context, listen: false);
  final PoseDetector _detector = PoseDetector(isStream: false);

  DetectedPose? lastDetectedPose;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _detectPose(InputImage image) async {
    if (state.isNotProcessing) {
      state.startProcessing();
      state.image = image;
      state.data = await _detector.detect(image);
      if (state.data!.landmarks.isNotEmpty) {
        _detectCurrentPose(state.data!.landmarks);
      }
      state.stopProcessing();
    }
  }

  void _detectCurrentPose(Map<PoseLandmarkType, PoseLandmark> landmarks) {
    if (_isCurrentPoseStanding(landmarks) &&
        lastDetectedPose != DetectedPose.standing) {
      setState(() {
        lastDetectedPose = DetectedPose.standing;
      });
    } else {
      setState(() {
        lastDetectedPose = DetectedPose.sitting;
      });
    }
  }

  bool _isCurrentPoseStanding(Map<PoseLandmarkType, PoseLandmark> landmarks) {
    final rightShoulderLandmark =
        state.data!.landmarks[PoseLandmarkType.RIGHT_SHOULDER];
    final rightKneeLandmark =
        state.data!.landmarks[PoseLandmarkType.RIGHT_KNEE];

    if (rightShoulderLandmark == null || rightKneeLandmark == null) {
      return false;
    }
    if (rightShoulderLandmark.position.dy < rightKneeLandmark.position.dy) {
      return true;
    }
    return false;
  }

  bool _isCurrentPoseSitting(Map<PoseLandmarkType, PoseLandmark> landmarks) {
    final rightShoulderLandmark =
        state.data!.landmarks[PoseLandmarkType.RIGHT_SHOULDER];
    final rightKneeLandmark =
        state.data!.landmarks[PoseLandmarkType.RIGHT_KNEE];

    if (rightShoulderLandmark == null || rightKneeLandmark == null) {
      return false;
    }
    if (rightShoulderLandmark.position.dy == rightKneeLandmark.position.dy) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return InputCameraView(
      cameraDefault: InputCameraType.rear,
      title:
          'Pose ${lastDetectedPose == DetectedPose.standing ? 'Standing' : 'Sitting'}',

      onImage: _detectPose,
      // resolutionPreset: ResolutionPreset.high,
      overlay: Consumer<PoseDetectionState>(
        builder: (_, state, __) {
          if (state.isEmpty) {
            return Container();
          }

          Size originalSize = state.size!;
          Size size = MediaQuery.of(context).size;

          // if image source from gallery
          // image display size is scaled to 360x360 with retaining aspect ratio
          if (state.notFromLive) {
            if (originalSize.aspectRatio > 1) {
              size = Size(360.0, 360.0 / originalSize.aspectRatio);
            } else {
              size = Size(360.0 * originalSize.aspectRatio, 360.0);
            }
          }

          return PoseOverlay(
            size: size,
            originalSize: originalSize,
            rotation: state.rotation,
            pose: state.data!,
          );
        },
      ),
    );
  }
}

class PoseDetectionState extends ChangeNotifier {
  InputImage? _image;
  Pose? _data;
  bool _isProcessing = false;

  InputImage? get image => _image;
  Pose? get data => _data;

  String? get type => _image?.type;
  InputImageRotation? get rotation => _image?.metadata?.rotation;
  Size? get size => _image?.metadata?.size;

  bool get isNotProcessing => !_isProcessing;
  bool get isEmpty => _data == null;
  bool get isFromLive => type == 'bytes';
  bool get notFromLive => !isFromLive;

  void startProcessing() {
    _isProcessing = true;
    notifyListeners();
  }

  void stopProcessing() {
    _isProcessing = false;
    notifyListeners();
  }

  set image(InputImage? image) {
    _image = image;

    if (notFromLive) {
      _data = null;
    }
    notifyListeners();
  }

  set data(Pose? data) {
    _data = data;
    notifyListeners();
  }
}
