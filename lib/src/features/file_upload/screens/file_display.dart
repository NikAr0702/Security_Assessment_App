import 'dart:io';
import 'package:flutter/material.dart';

class FileDisplay extends StatelessWidget {
  final File? file;

  const FileDisplay({Key? key, this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return file == null
        ? Container()
        : Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
            ),
            child: Image.file(file!),
          );
  }
}

