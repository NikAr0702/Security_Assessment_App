class FileValidator {
  static bool validateFileExtension(String fileName) {
    return fileName.endsWith('.txt') ||
        fileName.endsWith('.dart') ||
        fileName.endsWith('.jpg') ||
        fileName.endsWith('.jpeg') ||
        fileName.endsWith('.png');
  }
}
