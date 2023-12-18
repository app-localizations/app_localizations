import 'package:flutter/material.dart';

class LocalizedStringText extends StatelessWidget {
  const LocalizedStringText({super.key, required this.string});

  final String string;

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> children = [];
    String value = string;

    while (true) {
      final int startIndex = value.indexOf('{');
      if (startIndex == -1) {
        children.add(TextSpan(text: value));
        break;
      }
      final endIndex = value.indexOf('}', startIndex);
      if (endIndex == -1) {
        children.add(TextSpan(text: value));
        break;
      }
      final String left = value.substring(0, startIndex);
      final String middle = value.substring(startIndex, endIndex + 1);
      final String right = value.substring(endIndex + 1);

      children.add(TextSpan(text: left));
      children.add(
        WidgetSpan(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Text(
              middle,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.cyan,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      );
      value = right;
    }

    if (string.startsWith(' ')) {
      children.insert(
        0,
        TextSpan(
          text: ' ',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                backgroundColor: Colors.cyan,
              ),
        ),
      );
    }
    if (string.endsWith(' ')) {
      children.add(
        TextSpan(
          text: ' ',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                backgroundColor: Colors.cyan,
              ),
        ),
      );
    }

    return Text.rich(
      TextSpan(
        children: children,
      ),
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
