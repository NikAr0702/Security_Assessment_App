import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../../utils/text_extraction.dart';
import 'file_display.dart';

class FileUploadController extends GetxController {
  var selectedFileName = ''.obs;
  var isLoading = false.obs;
  var uploadStatus = ''.obs;
  var extractedText = ''.obs;
  var selectedFile = Rxn<File>();

  final TextExtractionService _textExtractionService =
      Get.put(TextExtractionService());

  // Function to pick file from device storage
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

  // Function to extract text from the selected file
  void extractText() async {
    if (selectedFile.value != null) {
      final text =
          await _textExtractionService.extractText(selectedFile.value!);
      extractedText.value = text;
    } else {
      Get.snackbar('Error', 'No file selected for text extraction');
    }
  }
}

class FileUploadScreen extends StatelessWidget {
  final FileUploadController controller = Get.put(FileUploadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload File'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
              Obx(() => FileDisplay(file: controller.selectedFile.value)),
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
            ],
          ),
        ),
      ),
    );
  }
}
