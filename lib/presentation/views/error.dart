import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  /// Defines the message that is displayed below the image.
  final String message;

  const ErrorView({
    Key? key,
    this.message = 'Something went wrong...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              Text(message)
            ],
          ),
        ),
      ),
    );
  }
}
