part of 'app_localization_languages_cubit.dart';

class AppLocalizationLanguagesState extends Equatable {
  const AppLocalizationLanguagesState({
    this.sourceLanguage = Language.en,
    this.selectedLanguage = Language.en,
    this.supportedLanguages = const [Language.en],
    this.needTranslateStringCount = const {},
  });

  final Language sourceLanguage;

  final Language selectedLanguage;

  final List<Language> supportedLanguages;

  // 语言需要翻译的文本数量
  final Map<Language, int> needTranslateStringCount;

  @override
  List<Object> get props => [
        sourceLanguage,
        selectedLanguage,
        supportedLanguages,
        needTranslateStringCount,
      ];

  AppLocalizationLanguagesState copyWith({
    Language? sourceLanguage,
    Language? selectedLanguage,
    List<Language>? supportedLanguages,
    Map<Language, int>? needTranslateStringCount,
  }) {
    return AppLocalizationLanguagesState(
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      supportedLanguages: supportedLanguages ?? this.supportedLanguages,
      needTranslateStringCount:
          needTranslateStringCount ?? this.needTranslateStringCount,
    );
  }
}
