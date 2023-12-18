import 'package:app_localizations/cubit/app_localization_languages_cubit.dart';
import 'package:app_localizations/cubit/app_localizations_cubit.dart';
import 'package:app_localizations/cubit/filter_and_sort_cubit.dart';
import 'package:app_localizations/widgets/app_localization_row.dart';
import 'package:app_localizations/widgets/localized_string_text_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLocalizationsView extends StatelessWidget {
  const AppLocalizationsView({
    super.key,
    required this.languages,
    required this.localizations,
  });

  final AppLocalizationLanguagesState languages;
  final AppLocalizationsState localizations;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterAndSortCubit, FilterAndSortState>(
      builder: (context, state) {
        final List<AppLocalizationString> strings;

        if (state.filter != "") {
          final filter = state.filter.toLowerCase();
          strings = localizations.strings.values.where((element) {
            // Key
            if (element.key.toLowerCase().contains(filter)) {
              return true;
            }
            // Source
            final source = element.localizations[languages.sourceLanguage];
            if (source != null) {
              if (source.value.toLowerCase().contains(filter)) {
                return true;
              }
            }
            // Selected
            if (languages.selectedLanguage != languages.sourceLanguage) {
              final selected =
                  element.localizations[languages.selectedLanguage];
              if (selected != null) {
                if (selected.value.toLowerCase().contains(filter)) {
                  return true;
                }
              }
            }
            return false;
          }).toList(growable: false);
        } else {
          strings = localizations.strings.values.toList(growable: false);
        }

        strings.sort((value1, value2) {
          switch (state.sortBy) {
            case AppLocalizationSortBy.key:
              return value1.key.compareTo(value2.key);
            case AppLocalizationSortBy.source:
              final source1 =
                  value1.localizations[languages.sourceLanguage]?.value ??
                      value1.key;
              final source2 =
                  value2.localizations[languages.sourceLanguage]?.value ??
                      value2.key;
              return source1.compareTo(source2);
            case AppLocalizationSortBy.value:
              final v1 =
                  value1.localizations[languages.selectedLanguage]?.value ??
                      value1.key;
              final v2 =
                  value2.localizations[languages.selectedLanguage]?.value ??
                      value2.key;
              return v1.compareTo(v2);
            case AppLocalizationSortBy.comment:
              final comment1 = value1.comment;
              final comment2 = value2.comment;
              return comment1.compareTo(comment2);
            case AppLocalizationSortBy.state:
              final state1 = value1
                  .localizedStringStateFromLanguage(languages.selectedLanguage);
              final state2 = value2
                  .localizedStringStateFromLanguage(languages.selectedLanguage);
              return state1.index.compareTo(state2.index);
          }
        });

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: strings.length,
          itemBuilder: (context, index) {
            if (index != 0) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Divider(
                      color: Colors.grey[300],
                      height: 1,
                      thickness: 1,
                    ),
                  ),
                  _itemBuilder(context, strings[index]),
                ],
              );
            }
            return _itemBuilder(context, strings[index]);
          },
        );
      },
    );
  }

  Widget _itemBuilder(BuildContext context, AppLocalizationString string) {
    final isEnter = ValueNotifier(false);
    return MouseRegion(
      onEnter: (event) => isEnter.value = true,
      onExit: (event) => isEnter.value = false,
      child: GestureDetector(
        onTap: () {
          showLocalizedStringTextEditor(
            context,
            string,
            languages.selectedLanguage,
          );
        },
        child: ValueListenableBuilder(
          valueListenable: isEnter,
          builder: (context, value, child) => Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            color: value ? Colors.grey[200] : null,
            child: child,
          ),
          child: AppLocalizationRow(
            string: string,
            languages: languages,
          ),
        ),
      ),
    );
  }
}
