import 'package:flutter/material.dart';

/// Custom Text Field Widget
/// 
/// Reusable text input component with consistent styling.
/// Supports validation, icons, and various input types.
/// Uses Vakıfbank color scheme for focus states.
class CustomTextField extends StatelessWidget {
  /// Text editing controller
  final TextEditingController controller;
  
  /// Field label text
  final String labelText;
  
  /// Optional hint text
  final String? hintText;
  
  /// Whether to obscure text (for passwords)
  final bool obscureText;
  
  /// Keyboard type for input
  final TextInputType keyboardType;
  
  /// Validation function
  final String? Function(String?)? validator;
  
  /// Optional prefix icon
  final Widget? prefixIcon;
  
  /// Optional suffix icon
  final Widget? suffixIcon;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        // Rounded border styling
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        // Light gray background
        filled: true,
        fillColor: Colors.grey[100],
        // Vakıfbank yellow focus border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFFDB913),
            width: 2,
          ),
        ),
      ),
    );
  }
}