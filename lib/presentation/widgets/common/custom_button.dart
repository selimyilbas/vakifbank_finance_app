import 'package:flutter/material.dart';

/// Custom Button Widget
/// 
/// Reusable button component with Vakıfbank branding.
/// Provides consistent styling across the application.
/// Supports loading state for async operations.
class CustomButton extends StatelessWidget {
  /// Button text to display
  final String text;
  
  /// Callback function when button is pressed
  final VoidCallback onPressed;
  
  /// Whether button is in loading state
  final bool isLoading;
  
  /// Optional custom background color
  final Color? backgroundColor;
  
  /// Optional custom text color
  final Color? textColor;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Full width button
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        // Disable button when loading
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          // Use Vakıfbank yellow by default
          backgroundColor: backgroundColor ?? const Color(0xFFFDB913),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            // Show loading indicator when processing
            ? const CircularProgressIndicator(color: Colors.black)
            // Show button text
            : Text(
                text,
                style: TextStyle(
                  // Black text on yellow background for contrast
                  color: textColor ?? Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}