import 'package:app_localizations/cubit/app_localization_languages_cubit.dart';
import 'package:app_localizations/cubit/filter_and_sort_cubit.dart';
import 'package:app_localizations/cubit/settings_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLocalizationTabBar extends StatelessWidget {
  const AppLocalizationTabBar({
    super.key,
    required this.languagesState,
    required this.filterAndSort,
  });

  final AppLocalizationLanguagesState languagesState;

  final FilterAndSortState filterAndSort;

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsCubit>().state;

    final List<Widget> children = [];

    if (settings.isShowKey) {
      addChild(
        Expanded(
          child: _buildTitle(
            context,
            title: "Key",
            sortBy: AppLocalizationSortBy.key,
          ),
        ),
        to: children,
      );
    }

    if (languagesState.selectedLanguage != languagesState.sourceLanguage) {
      addChild(
        Expanded(
          child: _buildTitle(
            context,
            title:
                "Default ${languagesState.sourceLanguage.name} (${languagesState.sourceLanguage.code})",
            sortBy: AppLocalizationSortBy.source,
          ),
        ),
        to: children,
      );
    }

    addChild(
      Expanded(
        child: _buildTitle(
          context,
          title:
              "${languagesState.selectedLanguage.name}(${languagesState.selectedLanguage.code})",
          sortBy: AppLocalizationSortBy.value,
        ),
      ),
      to: children,
    );

    addChild(
      Expanded(
        child: _buildTitle(
          context,
          title: "Comment",
          sortBy: AppLocalizationSortBy.comment,
        ),
      ),
      to: children,
    );

    if (languagesState.selectedLanguage != languagesState.sourceLanguage) {
      addChild(
        SizedBox(
          width: 80,
          child: _buildTitle(
            context,
            title: "State",
            sortBy: AppLocalizationSortBy.state,
          ),
        ),
        to: children,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 32 + 8,
      child: Row(children: children),
    );
  }

  Widget buildDefaultLanguage() {
    return Text(
      "Default ${languagesState.sourceLanguage.name} (${languagesState.sourceLanguage.code})",
    );
  }

  void addChild(Widget child, {required List<Widget> to}) {
    if (to.isEmpty) {
      to.add(child);
    } else {
      to.addAll(
        [const VerticalDivider(), child],
      );
    }
  }

  Widget _buildTitle(
    BuildContext context, {
    required String title,
    required AppLocalizationSortBy sortBy,
  }) {
    AppLocalizationSortBy currentSortBy = filterAndSort.sortBy;
    if (sortBy == AppLocalizationSortBy.value) {
      if (languagesState.sourceLanguage == languagesState.selectedLanguage) {
        if (currentSortBy == AppLocalizationSortBy.source) {
          currentSortBy = AppLocalizationSortBy.value;
        }
      }
    }

    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: currentSortBy == sortBy
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
          ),
        ],
      ),
      onPressed: () => context.read<FilterAndSortCubit>().setSortBy(sortBy),
    );
  }
}
