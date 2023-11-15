import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:metatube/components/snack_bar.dart';

class FileService {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  bool fieldsNotEmpty = false;

  File? _selectedFile;
  String _selectedDirectory = "";

  void  saveContents(context) async {
    final title = titleController.text;
    final description = descriptionController.text;
    final tags = tagsController.text;

    String textContent = "Title:\n\n$title\n\nDescription:\n\n$description\n\nTags:\n\n$tags";

    try{
      if (_selectedFile != null){
        await _selectedFile!.writeAsString(textContent);
      } else {
        final todayDate = getTodayDate();
        String metaDataDirPath = _selectedDirectory;
        if (metaDataDirPath.isEmpty){
          final directory = await FilePicker.platform.getDirectoryPath();
          _selectedDirectory = metaDataDirPath = directory!;
        }
        final filePath = "$metaDataDirPath/$todayDate - $title - Metadata.txt";
        final newFile = File(filePath);
        await newFile.writeAsString(textContent);

        SnackBarUtils.showSnackBar(context, "Saved Successfully", Icons.check_circle); 
        
      }

    } catch (e) {
      SnackBarUtils.showSnackBar(context, "$e", Icons.error);
    }

  }


  void loadContents(context) async {

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        File file = File(result.files.single.path!);
        _selectedFile = file;

        final fileContent = await file.readAsString();
        final lines = fileContent.split("\n\n");

        titleController.text = lines[1];
        descriptionController.text = lines[3];
        tagsController.text = lines[5];

        SnackBarUtils.showSnackBar(context, "File loaded", Icons.upload_file);
      } else {
        SnackBarUtils.showSnackBar(context, "No file selected", Icons.error);
      }
    } catch (e) {
      SnackBarUtils.showSnackBar(context, "$e", Icons.error);
    }
 
  }

  void createNewFile() {
    _selectedFile = null;
    titleController.clear();
    descriptionController.clear();
    tagsController.clear();
  }

  void changeFolder(context) async {
    try {
      final directoryPath = await FilePicker.platform.getDirectoryPath();
      _selectedDirectory = directoryPath!;
      _selectedFile = null;

      SnackBarUtils.showSnackBar(context, "Directory Changed successfully", Icons.file_download_done);
    } catch (e) {
      SnackBarUtils.showSnackBar(context, "Directory not found", Icons.error);
    }
    

  }

  static String getTodayDate() {
    final now = DateTime.now();
    final formatter = DateFormat("yyyy-MM-dd");
    final formattedDate = formatter.format(now);
    return formattedDate;
  }
   
}