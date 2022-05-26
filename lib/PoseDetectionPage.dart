import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learning_pose_detection/learning_pose_detection.dart';
import 'package:learning_input_image/learning_input_image.dart';
import 'dart:developer' as developer;

enum DetectedPose {
  standing,
  sitting,
}

class PoseDetectionPage extends StatefulWidget {
  const PoseDetectionPage({Key? key}) : super(key: key);

  @override
  _PoseDetectionPageState createState() => _PoseDetectionPageState();
}

class _PoseDetectionPageState extends State<PoseDetectionPage> {
  PoseDetectionState get state => Provider.of(context, listen: false);
  final PoseDetector _detector = PoseDetector(isStream: false);

  // Maximum difference between LEFT_MOUTH and LEFT_KNEE (to justify standing pose);
  int? _maxStandingHeightDifference;

  // late bool check, checkNext;
  late int _counter = 0;

  DetectedPose? lastDetectedPose = DetectedPose.standing;

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
        // Debugging
        //developer.log('Pose', error: _poseLandmarksToJSON(state.data!.landmarks));

        _updateMaxStandingHeightDifference(state.data!.landmarks);
        _detectCurrentPose(state.data!.landmarks);
      }
      state.stopProcessing();
    }
  }

  int? _getHeightDifference(PoseLandmarkType point1, PoseLandmarkType point2, Map<PoseLandmarkType, PoseLandmark> landmarks) {
    if (state.data!.landmarks[point1] == null || state.data!.landmarks[point2] == null) {
      return null;
    }
    final point1Y = state.data!.landmarks[point1]!.position.dy.toInt();
    final point2Y = state.data!.landmarks[point2]!.position.dy.toInt();

    return (point1Y - point2Y).abs();
  }

  void _updateMaxStandingHeightDifference(Map<PoseLandmarkType, PoseLandmark> landmarks) {
    final heightDifference = _getHeightDifference(PoseLandmarkType.LEFT_MOUTH, PoseLandmarkType.LEFT_KNEE, landmarks);
    if (heightDifference == null) {
      return;
    }

    if (_maxStandingHeightDifference == null || heightDifference > _maxStandingHeightDifference!) {
      setState(() {
        _maxStandingHeightDifference = heightDifference;
      });
      developer.log('Detected new max person height: $_maxStandingHeightDifference');
    }
  }

  void _detectCurrentPose(Map<PoseLandmarkType, PoseLandmark> landmarks) {
    if (lastDetectedPose != DetectedPose.standing && _isCurrentPoseStanding(landmarks)) {
      setState(() {
        lastDetectedPose = DetectedPose.standing;
      });
      developer.log('New pose: $lastDetectedPose');

      // Since initial pose = standing - we will not count first standing pose.
      // Then the pose should go to Sitting (so lastDetectedPose changes)
      // Then when it again changes from Sitting to Standing - we increment counter
      setState(() {
        _counter = _counter + 1;
      });
      developer.log('Squat detected!: $lastDetectedPose - $_counter');
    }
    if (lastDetectedPose != DetectedPose.sitting && _isCurrentPoseSitting(landmarks)) {
      setState(() {
        lastDetectedPose = DetectedPose.sitting;
      });
      developer.log('New pose: $lastDetectedPose');
    }
  }

  String _poseLandmarksToJSON(Map<PoseLandmarkType, PoseLandmark> landmarks) {
    final obj = {};
    final whitelist = [
      PoseLandmarkType.LEFT_ANKLE,
      PoseLandmarkType.LEFT_MOUTH,
      PoseLandmarkType.LEFT_HIP,
      PoseLandmarkType.LEFT_KNEE,
      PoseLandmarkType.LEFT_SHOULDER,
    ];
    landmarks.forEach((key, value) {
      if (whitelist.contains(key)) {
        obj[key.toString()] = {
          'direction': value.position.direction,
          'distance': value.position.distance,
          'distanceSquared': value.position.distanceSquared,
          'dx': value.position.dx,
          'dy': value.position.dy,
        };
      }
    });

    return jsonEncode(obj);
  }

  bool _isCurrentPoseStanding(Map<PoseLandmarkType, PoseLandmark> landmarks) {
    // Let's assume current pose is standing IF:
    // Distance between mouth and knee is max (-10%) - _maxStandingHeightDifference
    final heightDifference = _getHeightDifference(PoseLandmarkType.LEFT_MOUTH, PoseLandmarkType.LEFT_KNEE, landmarks);
    if (heightDifference == null || _maxStandingHeightDifference == null) {
      return false;
    }

    // 1 - 10% = 1 - 0.1 = 0.9
    if (heightDifference / _maxStandingHeightDifference! > 0.9) {
      return true;
    }

    return false;
  }

  bool _isCurrentPoseSitting(Map<PoseLandmarkType, PoseLandmark> landmarks) {
    // Let's assume current pose is sitting IF:
    // Distance between mouth and knee is less than 70% of max - _maxStandingHeightDifference
    // AND distance between hip and knee is approximately same (10% tolerance)
    final heightDifference = _getHeightDifference(PoseLandmarkType.LEFT_MOUTH, PoseLandmarkType.LEFT_KNEE, landmarks);
    if (heightDifference == null || _maxStandingHeightDifference == null) {
      return false;
    }

    final hipKneeDifference = _getHeightDifference(PoseLandmarkType.LEFT_HIP, PoseLandmarkType.LEFT_KNEE, landmarks);
    if (hipKneeDifference == null) {
      return false;
    }

    if (heightDifference / _maxStandingHeightDifference! > 0.7) {
      return false;
    }

    if (state.data!.landmarks[PoseLandmarkType.LEFT_HIP] == null || state.data!.landmarks[PoseLandmarkType.LEFT_KNEE] == null) {
      return false;
    }
    final point1Y = state.data!.landmarks[PoseLandmarkType.LEFT_HIP]!.position.dy.toInt();
    final point2Y = state.data!.landmarks[PoseLandmarkType.LEFT_KNEE]!.position.dy.toInt();

    return (point1Y / point2Y < 1.1 && point1Y / point2Y > 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InputCameraView(
            cameraDefault: InputCameraType.rear,
            title: 'Pose ${lastDetectedPose == DetectedPose.standing ? 'Standing' : 'Sitting'}',

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
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
              child: Text(
                "Number of pushups: $_counter",
                style: const TextStyle(color: Colors.grey, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ]),
      ],
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
