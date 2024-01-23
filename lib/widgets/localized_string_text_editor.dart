import 'package:app_localizations/cubit/app_localization_languages_cubit.dart';
import 'package:app_localizations/cubit/app_localizations_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showLocalizedStringTextEditor(
  BuildContext context,
  AppLocalizationString string,
  Language language,
) {
  showDialog(
    context: context,
    builder: (context) {
      return LayoutBuilder(builder: (context, constraints) {
        return LocalizedStringTextEditor(
          string: string,
          language: language,
          constraints: constraints,
        );
      });
    },
  );
}

class LocalizedStringTextEditor extends StatelessWidget {
  const LocalizedStringTextEditor({
    super.key,
    required this.string,
    required this.language,
    required this.constraints,
  });

  final AppLocalizationString string;
  final Language language;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: string.localizations[language]?.value ?? "",
    );

    final languages = context.read<AppLocalizationLanguagesCubit>();

    final ValueNotifier<String?> valueNotifier = ValueNotifier(language.code);

    final Map<String, Widget> children = {
      "Key": const Text("Key"),
    };

    for (var element in languages.state.supportedLanguages) {
      children[element.code] = Text(element.name);
    }

    return AlertDialog(
      title: const Text('Edit Localized String'),
      content: SizedBox(
        width: constraints.maxWidth * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder(
              valueListenable: valueNotifier,
              builder: (context, value, child) {
                return SizedBox(
                  width: constraints.maxWidth * 0.8,
                  child: CupertinoSlidingSegmentedControl(
                    children: children,
                    groupValue: value,
                    onValueChanged: (value) {
                      if (value == 'Key') {
                        valueNotifier.value = null;
                      } else {
                        valueNotifier.value = value ?? 'Key';
                      }

                      switch (value) {
                        case 'Key':
                          controller.text = string.key;
                          break;
                        default:
                          if (value != null) {
                            final language = Language.fromCode(value);
                            if (language != null) {
                              controller.text =
                                  string.localizations[language]?.value ?? "";
                            }
                          }
                      }
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Container(
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
          ],
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

            context.read<AppLocalizationsCubit>().updateLocalizedString(
                  context,
                  string: controller.text,
                  key: string.key,
                  language: language,
                );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
