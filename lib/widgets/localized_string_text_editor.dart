import 'package:app_localizations/cubit/app_localizations_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showLocalizedStringTextEditor(
  BuildContext context,
  AppLocalizationString string,
  Language language,
) {
  // showCupertinoDialog(
  //   context: context,
  //   builder: (context) {
  //     return LocalizedStringTextEditor();
  //   },
  // );
  showDialog(
    context: context,
    builder: (context) {
      return LocalizedStringTextEditor(
        string: string,
        language: language,
      );
    },
  );
}

class LocalizedStringTextEditor extends StatelessWidget {
  const LocalizedStringTextEditor({
    super.key,
    required this.string,
    required this.language,
  });

  final AppLocalizationString string;
  final Language language;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: string.localizations[language]?.value ?? "",
    );

    return AlertDialog(
      title: const Text('Edit Localized String'),
      content: Container(
        width: 400,
        height: 200,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          controller: controller,
          maxLines: 100,
          autofocus: true,
          textInputAction: TextInputAction.newline,
          decoration: const InputDecoration(
            hintText: "Enter localization string",
            border: InputBorder.none,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();

            context.read<AppLocalizationsCubit>();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
