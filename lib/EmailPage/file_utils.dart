import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

/// Opens a file using the OpenFile package.
/// 
/// [context]: The BuildContext for showing SnackBars.
/// [filePath]: The path of the file to open.
void openFile(BuildContext context, String filePath) {
  if (filePath.isNotEmpty) {
    final result = OpenFile.open(filePath);
    result.then((response) {
      if (response.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to open file: ${response.message}")),
        );
      }
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("File path not found!")),
    );
  }
}
