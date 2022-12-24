import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  static const String keyPrefix = 'LoadingWidget';

  /// Defines the heading text that wil be displayed under the image.
  final String heading;

  /// Optional body text which is displayed under the `heading`.
  final String? body;

  /// Sets the height of the image asset.
  final double assetHeight;

  /// Creates a generic 'loading' widget.
  ///
  /// Can be used for both loading screens, and activity/section
  /// completion modals which are defined in Figma.
  const LoadingWidget({
    Key? key,
    this.heading = 'Loading',
    this.body,
    this.assetHeight = 160.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
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
    );
  }
}
