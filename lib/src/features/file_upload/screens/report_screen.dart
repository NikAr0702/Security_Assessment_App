import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> errors = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Errors Found:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            errors.isEmpty
                ? const Text('No errors found!', style: TextStyle(fontSize: 16))
                : Expanded(
                    child: ListView.builder(
                      itemCount: errors.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.error, color: Colors.red),
                          title: Text(
                            errors[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
