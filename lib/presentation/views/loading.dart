import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  /// Defines the message that is displayed below the image.
  final String message;

  const LoadingView({
    Key? key,
    this.message = 'Getting everything ready...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey)),
            SizedBox(
              height: 20,
            ),
            Text('Please Wait...',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                ))
          ],
        ),
      ),
    );
  }
}
