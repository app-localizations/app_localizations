import 'dart:convert';
import 'dart:typed_data';

import 'package:app_localizations/cubit/app_localization_languages_cubit.dart';
import 'package:app_localizations/utils/pick_files.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'app_localizations_state.dart';

class AppLocalizationsCubit extends HydratedCubit<AppLocalizationsState> {
  AppLocalizationsCubit() : super(const AppLocalizationsState());

  @override
  AppLocalizationsState? fromJson(Map<String, dynamic> json) {
    return AppLocalizationsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AppLocalizationsState state) {
    return state.toJson();
  }

  void importFlutterIntlArbFiles(
      BuildContext context, List<CommomFile> files) async {
    debugPrint("importFlutterIntlArbFiles: $files");

    final languages = context.read<AppLocalizationLanguagesCubit>();

    final newStrings = Map<String, AppLocalizationString>.from(state.strings);
    final newSupportedLanguages =
        List<Language>.from(languages.state.supportedLanguages);

    for (var element in files) {
      final languageCode =
          element.name.split('.').first.replaceFirst('app_', '');
      if (languageCode.isEmpty) {
        return;
      }
      final language = Language.fromCode(languageCode);
      if (language == null) {
        continue;
      }

      if (!newSupportedLanguages.contains(language)) {
        newSupportedLanguages.add(language);
      }

      final Uint8List bytes = await element.bytes;
      if (bytes.isEmpty) {
        continue;
      }

      try {
        final arbString = utf8.decode(bytes);
        debugPrint("Arb: $arbString");

        final map = json.decode(arbString) as Map<String, dynamic>;

        for (var element in map.entries) {
          final key = element.key;
          final value = element.value as String;
          // newState = newState.addNewLocalizedString(language, key, value);

          AppLocalizationString? localizationString = newStrings[key];
          if (localizationString == null) {
            localizationString = AppLocalizationString(
              key: key,
              version: 0,
              comment: "",
              localizations: {
                language: LocalizedString(
                  key: key,
                  value: value,
                  language: language,
                  version: 0,
                ),
              },
            );
            newStrings[key] = localizationString;
          } else {
            final localizations = Map<Language, LocalizedString>.from(
              localizationString.localizations,
            );
            localizations[language] = LocalizedString(
              key: key,
              value: value,
              language: language,
              version: localizationString.version,
            );
            newStrings[key] = localizationString.copyWith(
              localizations: localizations,
            );
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }

      _updateNeedTranslateStringCount(languages, language);
    }

    emit(state.copyWith(strings: newStrings));

    languages.emit(languages.state.copyWith(
      supportedLanguages: newSupportedLanguages,
    ));
  }

  void _updateNeedTranslateStringCount(
    AppLocalizationLanguagesCubit languages,
    Language language,
  ) {
    final newNeedTranslateStringCount =
        Map<Language, int>.from(languages.state.needTranslateStringCount);

    int count = 0;

    for (var element in state.strings.values) {
      final localizedString = element.localizations[language];
      if (localizedString == null) {
        count++;
      } else if (localizedString.value.isEmpty) {
        count++;
      } else if (localizedString.version != element.version) {
        count++;
      }
    }

    newNeedTranslateStringCount[language] = count;
    languages.updateNeedTranslateStringCount(language, count);
  }
}
