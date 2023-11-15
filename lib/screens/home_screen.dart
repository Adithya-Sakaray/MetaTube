import 'package:flutter/material.dart';
import 'package:metatube/components/text_field.dart';
import 'package:metatube/services/file_service.dart';
import 'package:metatube/utils/app_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FileService fileService = FileService();

  @override
  void initState() {
    addListeners();
    super.initState();
  }

  @override
  void dispose() {
    removeListeners();
    super.dispose();
  }

  void addListeners() {
    List <TextEditingController> controllers = [
      fileService.tagsController,
      fileService.descriptionController,
      fileService.tagsController
    ];

    for(TextEditingController controller in controllers) {
      controller.addListener(() => _onFieldChanged());
    }
  }

  void removeListeners() {
    List <TextEditingController> controllers = [
      fileService.tagsController,
      fileService.descriptionController,
      fileService.tagsController
    ];

    for(TextEditingController controller in controllers) {
      controller.removeListener(() => _onFieldChanged());
    }
  }

  void _onFieldChanged() {
    setState(() {
      fileService.fieldsNotEmpty = fileService.titleController.text.isNotEmpty &&
                                   fileService.descriptionController.text.isNotEmpty &&
                                   fileService.tagsController.text.isNotEmpty;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.dark,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _mainButton(() => fileService.createNewFile(), "New File"),
                Row(
                  children: [
                    _actionButton(() => fileService.loadContents(context), Icons.file_upload),
                    const SizedBox(width: 8,),
                    _actionButton(() => fileService.changeFolder(context), Icons.folder)
                  ],
                )
              ],
            ),

            const SizedBox(height: 20,),

            MyTextField(
              maxLength: 100, 
              hintText: "Editor Video title", 
              maxLines: 3,
              controller: fileService.titleController
            ),

            const SizedBox(height: 40,),

            MyTextField(
              maxLength: 5000, 
              hintText: "Editor Video description", 
              maxLines: 5,
              controller: fileService.descriptionController
            ),

            const SizedBox(height: 40,),


            MyTextField(
              maxLength: 500, 
              hintText: "Editor Video tags", 
              maxLines: 4,
              controller: fileService.tagsController
            ),

            Row(
              children: [
                _mainButton(fileService.fieldsNotEmpty ? () => fileService.saveContents(context) : null, "Save File")
              ],
            )
          ],
        ),
      ),
    );
  }

  ElevatedButton _mainButton(Function()? onPressed, String text) {
    return ElevatedButton(
      onPressed: onPressed,
      style: _buttonStyle(),
      child: Text(text),
    );
  }

  IconButton _actionButton(Function()? onPressed, IconData icon){
    return IconButton(
      onPressed: onPressed, 
      splashRadius: 20,
      splashColor: AppTheme.accent,
      icon: Icon(icon),
      color: AppTheme.medium,
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppTheme.accent,
      foregroundColor: AppTheme.dark,
      disabledBackgroundColor: AppTheme.disableBackgroundColor,
      disabledForegroundColor: AppTheme.disabledForegroundColor
    );
  }
}
