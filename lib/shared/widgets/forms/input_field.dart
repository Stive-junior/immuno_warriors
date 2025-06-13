import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/core/constants/app_sizes.dart'; // Import des tailles

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
    this.maxLines = 1, // Par défaut une seule ligne
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
  late FocusNode _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _internalFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _internalFocusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      // Rebuild to update border color based on focus
    });
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
      focusNode: _internalFocusNode,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      cursorColor: AppColors.primaryColor, // Couleur du curseur futuriste
      style: TextStyle(
        // Style du texte de l'entrée
        color: AppColors.textColorPrimary,
        fontSize: AppSizes.fontSizeMedium,
        fontFamily: 'Rajdhani',
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(
          // Style du label
          color:
              _internalFocusNode.hasFocus
                  ? AppColors.primaryColor
                  : AppColors.textColorSecondary,
          fontSize: AppSizes.fontSizeMedium,
          fontFamily: 'Rajdhani',
          fontWeight: FontWeight.w500,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          // Style du hint
          color: AppColors.textColorSecondary.withOpacity(0.6),
          fontSize: AppSizes.fontSizeMedium,
          fontFamily: 'Rajdhani',
        ),
        prefixIcon:
            widget.prefixIcon != null
                ? Padding(
                  padding: const EdgeInsets.only(left: AppSizes.paddingSmall),
                  child: widget.prefixIcon,
                )
                : null,
        suffixIcon:
            widget.obscureText
                ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined, // Icônes stylisées
                    color: AppColors.textColorSecondary,
                    size: AppSizes.iconSizeMedium,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
                : widget.suffixIcon != null
                ? Padding(
                  padding: const EdgeInsets.only(right: AppSizes.paddingSmall),
                  child: widget.suffixIcon,
                )
                : null,
        filled: true,
        fillColor: AppColors.secondaryColor.withOpacity(
          0.4,
        ), // Fond du champ de saisie
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSizes.paddingMedium,
          horizontal: AppSizes.paddingMedium,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppSizes.formFieldRadius,
          ), // Rayon de bordure
          borderSide: BorderSide(
            color: AppColors.borderColor.withOpacity(0.6),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.formFieldRadius),
          borderSide: BorderSide(
            color: AppColors.borderColor.withOpacity(0.6),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.formFieldRadius),
          borderSide: BorderSide(
            color: AppColors.primaryColor,
            width: 2.0,
          ), // Bordure focus plus épaisse et colorée
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.formFieldRadius),
          borderSide: BorderSide(color: AppColors.errorColor, width: 2.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.formFieldRadius),
          borderSide: BorderSide(
            color: AppColors.errorColor,
            width: 2.5,
          ), // Bordure focus error plus épaisse
        ),
      ),
    );
  }
}
