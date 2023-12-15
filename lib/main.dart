import 'package:app_localizations/cubit/app_localization_languages_cubit.dart';
import 'package:app_localizations/cubit/app_localizations_cubit.dart';
import 'package:app_localizations/cubit/filter_and_sort_cubit.dart';
import 'package:app_localizations/cubit/settings_cubit.dart';
import 'package:app_localizations/utils/storage.dart';
import 'package:app_localizations/widgets/app_localization_tabbar.dart';
import 'package:app_localizations/widgets/app_localizations_view.dart';
import 'package:app_localizations/widgets/languages_sidebar.dart';
import 'package:app_localizations/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupHydratedBlocStorage();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => FilterAndSortCubit()),
      BlocProvider(create: (context) => SettingsCubit()),
      BlocProvider(create: (context) => AppLocalizationsCubit()),
      BlocProvider(create: (context) => AppLocalizationLanguagesCubit()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Localizations',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 9, 116, 243),
        ),
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'App Localizations'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const LanguagesSidebar(),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: BlocBuilder<AppLocalizationLanguagesCubit,
                AppLocalizationLanguagesState>(
              builder: (context, languages) {
                return Column(
                  children: [
                    const AppLocalizationsSearchBar(),
                    const Divider(height: 1, thickness: 1),
                    BlocBuilder<FilterAndSortCubit, FilterAndSortState>(
                      builder: (context, filterAndSort) {
                        return AppLocalizationTabBar(
                          languagesState: languages,
                          filterAndSort: filterAndSort,
                        );
                      },
                    ),
                    const Divider(height: 1, thickness: 1),
                    Expanded(
                      child: BlocBuilder<AppLocalizationsCubit,
                          AppLocalizationsState>(
                        builder: (context, localizations) {
                          return AppLocalizationsView(
                            languages: languages,
                            localizations: localizations,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
