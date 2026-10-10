import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_plus/tflite_flutter_plus.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:image/image.dart' as img;

class SignInterpreter extends StatefulWidget {
  const SignInterpreter({super.key});

  @override
  State<SignInterpreter> createState() => _SignInterpreterState();
}

class _SignInterpreterState extends State<SignInterpreter> {
  late CameraController _cameraController;
  late Interpreter _interpreter;
  bool _isProcessing = false;
  String _recognizedSign = "Waiting...";
  List<String> _labels = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModelAndLabels();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await _cameraController.initialize();
    if (mounted) {
      setState(() => _isInitialized = true);
      _startImageStream();
    }
  }

  Future<void> _loadModelAndLabels() async {
    try {
      // Configure interpreter options
      final options = InterpreterOptions()
        ..addDelegate(GpuDelegate())  // Use GPU acceleration if available
        ..useNnApiIfAvailable = true; // Use Neural Network API if available

      // Load TFLite model with options
      _interpreter = await Interpreter.fromAsset(
        'assets/sign_model.tflite',
        options: options,
      );
      
      // Load labels
      final labelFile = await DefaultAssetBundle.of(context)
          .loadString('assets/labels.txt');
      _labels = labelFile.split('\n');
      
      print('Model and labels loaded successfully');
    } catch (e) {
      print('Error loading model or labels: $e');
      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading model: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _startImageStream() {
    _cameraController.startImageStream((CameraImage image) {
      if (!_isProcessing) {
        _isProcessing = true;
        _processImage(image);
      }
    });
  }

  Future<void> _processImage(CameraImage image) async {
    try {
      final inputArray = _preProcessImage(image);
      
      // Prepare output tensor
      final outputShape = [1, _labels.length];
      final outputArray = List.filled(outputShape[0] * outputShape[1], 0.0)
          .reshape(outputShape);

      // Run inference
      _interpreter.run(inputArray, outputArray);

      // Process results
      final results = outputArray[0] as List<double>;
      final maxScore = results.reduce((a, b) => a > b ? a : b);
      final predictedIndex = results.indexOf(maxScore);

      if (maxScore > 0.5) {
        setState(() {
          _recognizedSign = '${_labels[predictedIndex]} (${(maxScore * 100).toStringAsFixed(1)}%)';
        });
      }
    } catch (e) {
      print('Error processing image: $e');
    } finally {
      _isProcessing = false;
    }
  }

  List _preProcessImage(CameraImage image) {
    // Convert YUV420 to RGB
    final img.Image? convertedImage = _convertYUV420ToRGB(image);
    if (convertedImage == null) return [];

    // Resize image to model input size (224x224)
    final resizedImage = img.copyResize(
      convertedImage,
      width: 224,
      height: 224,
    );

    // Normalize pixel values to [-1, 1]
    final inputArray = List.generate(
      224,
      (y) => List.generate(
        224,
        (x) {
          final pixel = resizedImage.getPixel(x, y);
          return [
            (pixel.r / 127.5) - 1,
            (pixel.g / 127.5) - 1,
            (pixel.b / 127.5) - 1,
          ];
        },
      ),
    );

    return inputArray;
  }

  img.Image? _convertYUV420ToRGB(CameraImage image) {
    final width = image.width;
    final height = image.height;
    final yPlane = image.planes[0].bytes;
    final uPlane = image.planes[1].bytes;
    final vPlane = image.planes[2].bytes;

    final rgbBytes = List<int>.filled(width * height * 3, 0);
    var rgbIndex = 0;

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final yIndex = y * width + x;
        final uvIndex = (y ~/ 2) * (width ~/ 2) + (x ~/ 2);

        final yValue = yPlane[yIndex];
        final uValue = uPlane[uvIndex];
        final vValue = vPlane[uvIndex];

        // YUV to RGB conversion
        var r = (yValue + 1.402 * (vValue - 128)).round();
        var g = (yValue - 0.344136 * (uValue - 128) - 0.714136 * (vValue - 128)).round();
        var b = (yValue + 1.772 * (uValue - 128)).round();

        // Clamp RGB values
        rgbBytes[rgbIndex++] = r.clamp(0, 255);
        rgbBytes[rgbIndex++] = g.clamp(0, 255);
        rgbBytes[rgbIndex++] = b.clamp(0, 255);
      }
    }

    return img.Image.fromBytes(
      width: width,
      height: height,
      bytes: Uint8List.fromList(rgbBytes).buffer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Language Interpreter'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: _isInitialized
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CameraPreview(_cameraController),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black87,
            child: Text(
              _recognizedSign,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _interpreter.close();
    super.dispose();
  }
}