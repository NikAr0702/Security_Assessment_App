import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

class TextExtractionService extends GetxService {
  // Function to extract text from an image file using Tesseract OCR
  Future<String> extractText(File imageFile) async {
    String extractedText = '';
    try {
      // Specify the path to the tessdata directory
      extractedText = await FlutterTesseractOcr.extractText(
        imageFile.path,
        language: 'eng',
        args: {
          "tessdata": "assets/tessdata/",
          "preserve_interword_spaces": "1",
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to extract text: $e');
    }
    return extractedText;
  }
}
