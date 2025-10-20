import 'dart:io';
import 'dart:async';

import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_lottie_loading_widget.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon_button.dart';
import 'package:camera/camera.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanVehicleRegistrationNumberScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const ScanVehicleRegistrationNumberScreen({
    super.key,
    required this.cameras,
  });

  @override
  State<ScanVehicleRegistrationNumberScreen> createState() =>
      _ScanVehicleRegistrationNumberScreenState();
}

class _ScanVehicleRegistrationNumberScreenState
    extends State<ScanVehicleRegistrationNumberScreen> {
  late CameraController cameraController;
  late Future<void> cameraValue;
  bool isFlashOn = false;
  Timer? _timer; // Timer for automatic picture capture
  String? extractedTextFromFile = '';

  void startCamera(int camera) {
    cameraController = CameraController(
      widget.cameras[camera],
      ResolutionPreset.high,
      enableAudio: false,
    );
    cameraValue = cameraController.initialize();
  }

  void startAutomaticCapture() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      takePicture(); // Automatically take a picture every second
    });
  }

  void stopAutomaticCapture() {
    _timer?.cancel(); // Cancel the timer if needed
  }

  Future<void> takePicture() async {
    if (cameraController.value.isTakingPicture ||
        !cameraController.value.isInitialized) {
      return;
    }

    XFile image = await cameraController.takePicture();
    File capturedFile = File(image.path);
    await extractText(capturedFile); // Process the text

    // Optionally, you can print the extracted text directly
    print("Captured Image: ${image.path}");
  }

  Future<void> extractText(File file) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    textRecognizer.close();

    // Format the extracted text
    String formattedText = formatText(text);
    setState(() {
      extractedTextFromFile = formattedText;
    });

    print("EXTRACTED TEXT: $extractedTextFromFile");
  }

  String formatText(String input) {
    // Remove all spaces and special characters
    String formatted = input
        .replaceAll(' ', '')
        .replaceAll('IND', '')
        .replaceAll('INDIA', '')
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .toUpperCase();
    return formatted;
  }

  void flash() async {
    if (isFlashOn) {
      await cameraController.setFlashMode(FlashMode.torch);
    } else {
      await cameraController.setFlashMode(FlashMode.off);
    }
  }

  Future<void> saveExtractedText() async {
    // Implement the functionality to save the extracted text
    // You can save it to a file or any storage solution you prefer
    // Here, we are just printing it
    print("Saving extracted text: $extractedTextFromFile");
    Navigator.pop(context,
        extractedTextFromFile); // Pop the screen with the extracted text
  }

  @override
  void initState() {
    super.initState();
    startCamera(0);
    startAutomaticCapture(); // Start the timer for automatic capture
  }

  @override
  void dispose() {
    cameraController.dispose(); // Dispose of the camera controller
    stopAutomaticCapture(); // Cancel the timer when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: cameraValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox.expand(
              child:
                  CameraPreview(cameraController), // Show camera preview only
            );
          } else {
            return const Center(
              child: BuildLottieLoadingWidget(),
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Flash toggle button
            BuildSvgIconButton(
              assetImagePath: isFlashOn
                  ? AppAssets.flashActiveIcon
                  : AppAssets.flashInactiveIcon,
              iconHeight: 30,
              onTap: () {
                setState(() {
                  isFlashOn = !isFlashOn;
                });
                flash();
              },
            ),
            const SizedBox(width: 10),
            // Extracted text display
            Text(
              (extractedTextFromFile != null &&
                      extractedTextFromFile!.length > 14)
                  ? extractedTextFromFile!.substring(0, 14)
                  : extractedTextFromFile ?? '',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(fontSize: 20),
              maxLines: 1,
            ),
            const Spacer(),
            // Done button
            BuildSvgIconButton(
              assetImagePath: AppAssets.doneIcon,
              iconHeight: 55,
              onTap: () {
                saveExtractedText(); // Save the extracted text and navigate back
              },
            ),
          ],
        ),
      ),
    );
  }
}
