import 'dart:convert';

import 'package:app_localizations/cubit/app_localization_languages_cubit.dart';
import 'package:app_localizations/utils/pick_files.dart';
import 'package:archive/archive.dart';
import 'package:equatable/equatable.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
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

  Future<void> export(BuildContext context) async {
    final Archive archive = Archive();

    final languages = context.read<AppLocalizationLanguagesCubit>();
    final supportedLanguages = languages.state.supportedLanguages;
    for (var language in supportedLanguages) {
      String arb = "{";
      for (var element in state.strings.values) {
        final localizedString = element.localizations[language];
        if (localizedString == null) {
          continue;
        }
        final key = localizedString.key;
        final value = localizedString.value
            .replaceAll("\n", "\\n")
            .replaceAll("\"", "\\\"");
        arb += '\n\t"$key": "$value",';
      }
      arb = arb.substring(0, arb.length - 1);
      arb += "\n}";
      final bytes = utf8.encode(arb);
      archive.addFile(ArchiveFile(
        'app_${language.code}.arb',
        bytes.length,
        bytes,
      ));
    }

    final ZipEncoder encoder = ZipEncoder();
    final zipBytes = encoder.encode(archive);
    if (zipBytes == null) {
      throw Exception('zipBytes is null');
    }

    await FileSaver.instance.saveFile(
      name: 'images',
      bytes: Uint8List.fromList(zipBytes),
      ext: 'zip',
    );
  }

  void importFlutterIntlArbFiles(
      BuildContext context, List<CommomFile> files) async {
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
        final map = json.decode(arbString) as Map<String, dynamic>;

        for (var element in map.entries) {
          final key = element.key;
          final value = element.value as String;

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

  void updateLocalizedString(
    BuildContext context, {
    required String string,
    required String key,
    required Language language,
  }) {
    final newStrings = Map<String, AppLocalizationString>.from(state.strings);
    var localizationString = newStrings[key];
    if (localizationString == null) {
      return;
    }
    final localizations = Map<Language, LocalizedString>.from(
      localizationString.localizations,
    );

    final languages = context.read<AppLocalizationLanguagesCubit>();

    if (string.isEmpty) {
      localizations.remove(language);
    } else {
      localizations[language] = LocalizedString(
        key: key,
        value: string,
        language: language,
        version: languages.state.sourceLanguage == language
            ? localizationString.version + 1
            : localizationString.version,
      );
    }

    newStrings[key] = localizationString.copyWith(
      localizations: localizations,
      version: languages.state.sourceLanguage == language
          ? localizationString.version + 1
          : localizationString.version,
    );

    emit(state.copyWith(strings: newStrings));

    /// Update need translate string count
    _updateNeedTranslateStringCountOfAllLanguage(languages);
  }

  void _updateNeedTranslateStringCount(
    AppLocalizationLanguagesCubit languages,
    Language language,
  ) {
    languages.emit(languages.state.copyWith(
      needTranslateStringCount: {
        ...languages.state.needTranslateStringCount,
        language: _calculateNeedTranslateStringCount(
          strings: state.strings,
          language: language,
        ),
      },
    ));
  }

  void _updateNeedTranslateStringCountOfAllLanguage(
      AppLocalizationLanguagesCubit languages) async {
    compute(
      (message) {
        final AppLocalizationLanguagesState languages = message[0];
        final Map<String, AppLocalizationString> strings = message[1];

        final needTranslateStringCount = <Language, int>{};
        for (var element in languages.supportedLanguages) {
          needTranslateStringCount[element] =
              _calculateNeedTranslateStringCount(
            strings: strings,
            language: element,
          );
        }
        return needTranslateStringCount;
      },
      <dynamic>[languages.state, state.strings],
    ).then(
      (value) => languages.emit(
        languages.state.copyWith(
          needTranslateStringCount: value,
        ),
      ),
    );
  }
}

int _calculateNeedTranslateStringCount({
  required Map<String, AppLocalizationString> strings,
  required Language language,
}) {
  int count = 0;

  for (var element in strings.values) {
    final localizedString = element.localizations[language];
    if (localizedString == null) {
      count++;
    } else if (localizedString.value.isEmpty) {
      count++;
    } else if (localizedString.version != element.version) {
      count++;
    }
  }

  return count;
}
