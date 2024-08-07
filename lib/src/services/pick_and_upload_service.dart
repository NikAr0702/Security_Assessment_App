import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class PickAndUploadService extends GetxService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  var selectedFileName = ''.obs;
  var isLoading = false.obs;
  var uploadStatus = ''.obs;
  File? selectedFile;

  // Function to pick file from device storage
  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        selectedFileName.value = result.files.single.name;
        selectedFile = File(result.files.single.path!);
        // Log the file path to see if it was picked correctly
        print('File path: ${selectedFile!.path}');
      } else {
        Get.snackbar('Error', 'No file selected');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick file');
    }
  }

  // Function to upload the file to Firebase Storage
  Future<void> uploadFile() async {
    if (selectedFile != null) {
      isLoading.value = true;
      uploadStatus.value = 'Uploading...';

      try {
        // Create a reference to the location you want to upload the file to
        // Ensure to specify the correct bucket
        Reference ref = _storage
            .refFromURL('gs://security-app-1fd9b.appspot.com')
            .child('uploads/${selectedFile!.path.split('/').last}');

        // Upload the file
        UploadTask uploadTask = ref.putFile(selectedFile!);

        // Wait for the upload to complete
        await uploadTask;

        // Show success message
        uploadStatus.value = 'File uploaded successfully';
        Get.snackbar('Success', uploadStatus.value);
      } catch (e) {
        uploadStatus.value = 'Failed to upload file';
        Get.snackbar('Error', uploadStatus.value);
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar('Error', 'No file selected to upload');
    }
  }
}
