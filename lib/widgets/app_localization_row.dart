import 'package:app_localizations/cubit/app_localization_languages_cubit.dart';
import 'package:app_localizations/cubit/app_localizations_cubit.dart';
import 'package:app_localizations/cubit/settings_cubit.dart';
import 'package:app_localizations/widgets/localized_string_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLocalizationRow extends StatelessWidget {
  const AppLocalizationRow({
    super.key,
    required this.string,
    required this.languages,
  });

  final AppLocalizationString string;
  final AppLocalizationLanguagesState languages;

  @override
  Widget build(BuildContext context) {
    final localizedString = string.localizations[languages.selectedLanguage];
    final isNew = localizedString == null;
    final isNeedReview = localizedString?.version != string.version;

    final settings = context.read<SettingsCubit>().state;

    // final isNew = true;
    // final isNeedReview = true;

    final List<Widget> children = [];

    if (settings.isShowKey) {
      addChild(
        Expanded(
          child: Text(
            string.key,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        to: children,
      );
    }

    if (languages.selectedLanguage != languages.sourceLanguage) {
      final text =
          string.localizations[languages.sourceLanguage]?.value ?? string.key;
      addChild(
        Expanded(
          // child: Text(
          //   text,
          //   style: Theme.of(context).textTheme.bodySmall,
          // ),
          child: LocalizedStringText(
            string: text,
          ),
        ),
        to: children,
      );
    }

    addChild(
      Expanded(
        // child: Text(
        //   localizedString?.value ?? "--",
        //   style: Theme.of(context).textTheme.bodySmall,
        // ),
        child: LocalizedStringText(string: localizedString?.value ?? "--"),
      ),
      to: children,
    );

    addChild(
      Expanded(
        child: Text(
          string.comment,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
      to: children,
    );

    if (languages.selectedLanguage != languages.sourceLanguage) {
      addChild(
        SizedBox(
          width: 80,
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isNew
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "NEW",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                      ),
                    )
                  : isNeedReview
                      ? CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            //
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "NEEDS REVIEW",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                            ),
                          ),
                        )
                      : CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            //
                          },
                          child: Icon(
                            CupertinoIcons.check_mark_circled,
                            color: Colors.green[400],
                            size: 16,
                          ),
                        ),
            ],
          ),
        ),
        to: children,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  void addChild(Widget child, {required List<Widget> to}) {
    if (to.isEmpty) {
      to.add(child);
    } else {
      to.addAll(
        [const VerticalDivider(color: Colors.transparent), child],
      );
    }
  }
}
