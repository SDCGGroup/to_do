import 'package:flutter/material.dart';
import 'package:to_do_app/presentation/widgets/widget_delegate.dart';

typedef _OnSelectCallback = void Function(
  String text,
);

class SingleSelectList extends StatefulWidget {
  static const keyPrefix = 'SingleSelectList';

  final String title;
  final int selectedOptionIndex;
  final List<String>? optionsList;
  final _OnSelectCallback onTap;

  const SingleSelectList({
    Key? key,
    required this.title,
    required this.selectedOptionIndex,
    this.optionsList,
    required this.onTap,
  }) : super(key: key);

  @override
  State<SingleSelectList> createState() => _SingleSelectListState();
}

class _SingleSelectListState extends State<SingleSelectList> {
  bool _isExpanded = false;
  late int _selectedIndex;

  @override
  void initState() {
    if (mounted) {
      _selectedIndex = widget.selectedOptionIndex;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
                WidgetDelegate(
                  primaryWidget: () => const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.black,
                  ),
                  alternateWidget: () => const Icon(Icons.close),
                  shouldShowPrimary: !_isExpanded,
                ),
              ],
            ),
          ),
        ),
        WidgetDelegate(
          shouldShowPrimary: _isExpanded && widget.optionsList != null,
          primaryWidget: (() {
            return Flexible(
              child: ListView.separated(
                key: const Key('${SingleSelectList.keyPrefix}-optionsList'),
                physics: const ClampingScrollPhysics(),
                separatorBuilder: (_, __) => const Divider(
                  height: 0,
                ),
                shrinkWrap: true,
                itemCount: widget.optionsList!.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                        _selectedIndex = index;
                      });
                      widget.onTap(
                        widget.optionsList![index],
                      );
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    title: Text(
                      widget.optionsList![index],
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: index == _selectedIndex
                                ? Colors.blueAccent
                                : Colors.black,
                          ),
                    ),
                  );
                },
              ),
            );
          }),
          alternateWidget: () => const SizedBox.shrink(),
        )
      ],
    );
  }
}
