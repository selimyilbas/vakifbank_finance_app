import 'package:flutter/material.dart';

/// Loading Widget
/// 
/// Displays a centered loading indicator with optional message.
/// Used throughout the app for consistent loading states.
class LoadingWidget extends StatelessWidget {
  /// Optional loading message to display
  final String? message;

  const LoadingWidget({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular progress indicator
          const CircularProgressIndicator(),
          // Show message if provided
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ],
      ),
    );
  }
}