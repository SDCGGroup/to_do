import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:to_do_app/routes/page_routes.dart';

typedef OnPressCallback = void Function();

class BottomRightButton extends StatelessWidget {
  const BottomRightButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  static const keyPrefix = 'BottomRightButton';

  final String text;
  final IconData icon;
  final OnPressCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0, bottom: 12),
        child: Container(
          width: 120,
          child: ElevatedButton(
            key: Key('$keyPrefix-$text'),
            onPressed: () {
              Routemaster.of(context).push('${RelativePageRoutes.task}/0');
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 25,
                ),
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
