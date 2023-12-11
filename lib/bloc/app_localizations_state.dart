part of 'app_localizations_bloc.dart';

sealed class AppLocalizationsState extends Equatable {
  const AppLocalizationsState({
    this.sourceLanguage = Language.en,
    this.strings = const {},
  });

  final Language sourceLanguage;
  final Map<String, AppLocalizationString> strings;

  @override
  List<Object> get props => [
        sourceLanguage,
        strings,
      ];
}

final class AppLocalizationsInitial extends AppLocalizationsState {}

////

class AppLocalizationString extends Equatable {
  const AppLocalizationString({
    required this.key,
    required this.version,
    required this.localizations,
  });

  final String key;

  final int version;

  final Map<Language, LocalizedString> localizations;

  @override
  List<Object?> get props => [key, version, localizations];
}

/// 已本地化的字符串
class LocalizedString extends Equatable {
  const LocalizedString({
    required this.key,
    required this.value,
    required this.languageCode,
    required this.version,
  });

  final String key;
  final String value;
  final Language languageCode;
  final int version;

  @override
  List<Object?> get props => [
        key,
        value,
        languageCode,
        version,
      ];
}

enum Language {
  en('en', 'English'),
  ja('ja', 'Japanese'),
  ko('ko', 'Korean'),
  zh('zh', 'Chinese'),
  // ignore: constant_identifier_names
  zh_Hant('zh-Hant', 'Chinese (Traditional)'),
  // ignore: constant_identifier_names
  zh_Hans('zh-Hans', 'Chinese (Simplified)'),
  ;

  const Language(this.code, this.name);

  final String code;
  final String name;
}
