import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:security_assessment_app/src/features/file_upload/screens/report_screen.dart';
import '../../../utils/text_extraction.dart';
import '../../../utils/text_analyzer.dart';

class FileUploadController extends GetxController {
  var selectedFileName = ''.obs;
  var isLoading = false.obs;
  var uploadStatus = ''.obs;
  var extractedText = ''.obs;
  var analysisResult = ''.obs;
  var analysisErrors = <String>[].obs;
  var selectedFile = Rxn<File>();

  final TextExtractionService _textExtractionService =
      Get.put(TextExtractionService());
  final TextAnalyzerService _textAnalyzerService =
      Get.put(TextAnalyzerService());

  void pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        selectedFileName.value = result.files.single.name;
        selectedFile.value = File(result.files.single.path!);
        print('File path: ${selectedFile.value!.path}');
      } else {
        Get.snackbar('Error', 'No file selected');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick file');
    }
  }

  void extractText() async {
    if (selectedFile.value != null) {
      final text =
          await _textExtractionService.extractText(selectedFile.value!);
      extractedText.value = text;

      final analysis = _textAnalyzerService.analyzeText(text);
      analysisResult.value = analysis['message'];

      if (analysis['status'] == false) {
        analysisErrors.add(analysisResult.value);
      }

      Get.snackbar('Analysis Result', analysisResult.value);
    } else {
      Get.snackbar('Error', 'No file selected for text extraction');
    }
  }

  void navigateToReportScreen() {
    Get.to(() => const ReportScreen(), arguments: analysisErrors);
  }
}

class FileUploadScreen extends StatelessWidget {
  final FileUploadController controller = Get.put(FileUploadController());

  FileUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload File'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => Text(
                      controller.selectedFileName.value.isEmpty
                          ? 'No file selected'
                          : 'Selected file: ${controller.selectedFileName.value}',
                      style: const TextStyle(fontSize: 16),
                    )),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.pickFile,
                  child: const Text('Pick File'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.extractText,
                  child: const Text('Extract Text'),
                ),
                const SizedBox(height: 20),
                Obx(() => Text(
                      controller.extractedText.value,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    )),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.navigateToReportScreen,
                  child: const Text('Analysis Report'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
