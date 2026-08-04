import 'package:flutter/material.dart';

Future<String?> showTextInputDialog({
  required BuildContext context,
  required String title,
  required String actionLabel,
  String? cancelLabel,
  String? hintText,
  String initialText = '',
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _TextInputDialog(
      title: title,
      actionLabel: actionLabel,
      cancelLabel: cancelLabel,
      hintText: hintText,
      initialText: initialText,
    ),
  );
}

class _TextInputDialog extends StatefulWidget {
  const _TextInputDialog({
    required this.title,
    required this.actionLabel,
    required this.initialText,
    this.cancelLabel,
    this.hintText,
  });

  final String title;
  final String actionLabel;
  final String? cancelLabel;
  final String? hintText;
  final String initialText;

  @override
  State<_TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<_TextInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: TextField(
      controller: _controller,
      autofocus: true,
      decoration: InputDecoration(hintText: widget.hintText),
      onSubmitted: (_) => _submit(),
    ),
    actions: [
      if (widget.cancelLabel case final label?)
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(label),
        ),
      FilledButton(onPressed: _submit, child: Text(widget.actionLabel)),
    ],
  );

  void _submit() => Navigator.pop(context, _controller.text);
}
