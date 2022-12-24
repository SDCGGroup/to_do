import 'package:flutter/material.dart';

typedef OnPressCallback = void Function(int id);

class TaskCard extends StatelessWidget {
  const TaskCard({
    Key? key,
    required this.id,
    required this.title,
    required this.selected,
    required this.onPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  static const keyPrefix = 'TaskCard';

  final int id;
  final String? title;
  final bool selected;
  final OnPressCallback onPressed;
  final OnPressCallback onEditPressed;
  final OnPressCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Material(
        clipBehavior: Clip.hardEdge,
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          color: Color.fromARGB(255, 199, 214, 238),
          child: Row(
            key: ValueKey('$keyPrefix-$id'),
            children: [
              Expanded(
                flex: 6,
                child: ListTile(
                  key: ValueKey('$keyPrefix-$id-name'),
                  onTap: () => onPressed(id),
                  leading: selected
                      ? const Icon(
                          Icons.check_box_outlined,
                          color: Colors.black,
                          size: 35,
                        )
                      : const Icon(
                          Icons.check_box_outline_blank_outlined,
                          size: 35,
                        ),
                  title: Text(
                    title ?? '',
                    key: ValueKey('$keyPrefix-$title'),
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  key: ValueKey('$keyPrefix-$id-editButton'),
                  onPressed: () => onEditPressed(id),
                  icon: const Icon(
                    Icons.edit,
                    size: 35,
                    color: Color.fromARGB(255, 99, 98, 98),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  key: ValueKey('$keyPrefix-$id-deleteButton'),
                  onPressed: () => onDeletePressed(id),
                  icon: const Icon(
                    Icons.delete,
                    size: 35,
                    color: Color.fromARGB(255, 99, 98, 98),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
