import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;

  final String? hintText;
  final String? labelText;

  final int? maxLines;
  final int? minLines;
  final int? maxLength;

  final TextInputType? keyboardType;

  final bool obscureText;
  final bool enabled;

  final TextAlign textAlign;
  final TextDirection textDirection;

  final TextStyle? style;
  final InputDecoration? decoration;

  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;

  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.labelText,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.textAlign = TextAlign.right,
    this.textDirection = TextDirection.rtl,
    this.style,
    this.decoration,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,

      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,

      keyboardType: keyboardType,

      obscureText: obscureText,
      enabled: enabled,

      textAlign: textAlign,
      textDirection: textDirection,

      style: style,

      onChanged: onChanged,
      onTap: onTap,
      onSubmitted: onSubmitted,

      contextMenuBuilder: (context, editableTextState) {
        return AdaptiveTextSelectionToolbar.buttonItems(
          anchors: editableTextState.contextMenuAnchors,
          buttonItems: [
            ContextMenuButtonItem(
              label: 'نسخ',
              onPressed: () {
                editableTextState.copySelection(SelectionChangedCause.toolbar);
              },
            ),
            ContextMenuButtonItem(
              label: 'قص',
              onPressed: () {
                editableTextState.cutSelection(SelectionChangedCause.toolbar);
              },
            ),
            ContextMenuButtonItem(
              label: 'لصق',
              onPressed: () {
                editableTextState.pasteText(SelectionChangedCause.toolbar);
              },
            ),
            ContextMenuButtonItem(
              label: 'تحديد الكل',
              onPressed: () {
                editableTextState.selectAll(SelectionChangedCause.toolbar);
              },
            ),
          ],
        );
      },

      decoration:
          decoration ??
          InputDecoration(hintText: hintText, labelText: labelText),
    );
  }
}
