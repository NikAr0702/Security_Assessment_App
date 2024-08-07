import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class FileUploadService extends GetxService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Function to upload file to Firebase Storage
  Future<void> uploadFile(File file) async {
    try {
      // Create a reference to the location you want to upload the file to
      // Ensure to specify the correct bucket
      Reference ref = _storage
          .refFromURL('gs://security-app-1fd9b.appspot.com')
          .child('uploads/${file.path.split('/').last}');

      // Upload the file
      UploadTask uploadTask = ref.putFile(file);

      // Wait for the upload to complete
      await uploadTask;

      // Show success message
      Get.snackbar('Success', 'File uploaded successfully');
    } catch (e) {
      // Show error message if the upload fails
      Get.snackbar('Error', 'Failed to upload file');
    }
  }
}
