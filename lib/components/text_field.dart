import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metatube/components/snack_bar.dart';
import 'package:metatube/utils/app_style.dart';

class MyTextField extends StatefulWidget {
  const MyTextField(
      {super.key,
      required this.maxLength,
      this.maxLines,
      required this.hintText,
      required this.controller});

  final int maxLength;
  final int? maxLines;
  final String hintText;
  final TextEditingController controller;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  void copyToClipboard(context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    SnackBarUtils.showSnackBar(context, "Text copied", Icons.content_copy);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      controller: widget.controller,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      keyboardType: TextInputType.multiline,
      cursorColor: AppTheme.accent,
      style: AppTheme.inputStyle,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTheme.hintStyle,
        suffixIcon: _copyButton(context),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppTheme.accent),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppTheme.medium),
            borderRadius: BorderRadius.circular(10)),
        counterStyle: AppTheme.counterStyle,
      ),
    );
  }

  IconButton _copyButton(BuildContext context) {
    return IconButton(
      onPressed: widget.controller.text.isNotEmpty
          ? () => copyToClipboard(context, widget.controller.text)
          : null,
      color: AppTheme.accent,
      splashColor: AppTheme.accent,
      disabledColor: AppTheme.medium,
      splashRadius: 20,
      icon: const Icon(Icons.content_copy_outlined),
      
    );
  }
}
