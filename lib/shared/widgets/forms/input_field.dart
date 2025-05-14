import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Pour les types d'entrée
import 'package:immuno_warriors/shared/ui/app_styles.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';

class InputField extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;

  const InputField({
    super.key,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.validator,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines,
    this.minLines,
    this.focusNode,
    this.onChanged,
    this.onEditingComplete,
  });

  @override
  InputFieldState createState() => InputFieldState();
}

class InputFieldState extends State<InputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText
            ? IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.errorColor),
        ),
      ),
      style: AppStyles.bodyMedium,
    );
  }
}