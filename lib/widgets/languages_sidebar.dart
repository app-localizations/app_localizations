import 'package:app_localizations/cubit/app_localization_languages_cubit.dart';
import 'package:app_localizations/cubit/app_localizations_cubit.dart';
import 'package:app_localizations/utils/pick_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguagesSidebar extends StatelessWidget {
  const LanguagesSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppLocalizationLanguagesCubit>();
    return BlocBuilder<AppLocalizationLanguagesCubit,
        AppLocalizationLanguagesState>(
      bloc: cubit,
      builder: (context, state) {
        final totalStringCount =
            context.read<AppLocalizationsCubit>().state.strings.length;
        return SizedBox(
          width: 180,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.supportedLanguages.length,
                  itemBuilder: (context, index) {
                    final language = state.supportedLanguages[index];
                    final needTranslateStringCount =
                        state.needTranslateStringCount[language] ?? 0;
                    // 计算已翻译文本的百分比
                    final translatedStringCount =
                        totalStringCount - needTranslateStringCount;
                    final percent = translatedStringCount / totalStringCount;

                    return ListTile(
                      title: Text(
                        language.name,
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: language != state.sourceLanguage
                          ? percent == 1
                              ? Icon(
                                  CupertinoIcons.check_mark_circled,
                                  color: Colors.green[400],
                                  size: 16,
                                )
                              : Text(
                                  "${(percent * 100).toInt().toStringAsFixed(0)}%",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                )
                          : null,
                      selected: language == state.selectedLanguage,
                      onTap: () {
                        cubit.changeSelectedLanguage(language);
                      },
                    );
                  },
                ),
              ),
              Row(
                children: [
                  MenuAnchor(
                    menuChildren: [
                      MenuItemButton(
                        child: const Text("Add Key"),
                        onPressed: () {
                          //
                        },
                      ),
                      MenuItemButton(
                        child: const Text("Add Language"),
                        onPressed: () {
                          //
                        },
                      ),
                      MenuItemButton(
                        child: const Text("Import Arb Files"),
                        onPressed: () {
                          pickFiles(context).then((value) {
                            if (value.isEmpty) {
                              return;
                            }
                            context
                                .read<AppLocalizationsCubit>()
                                .importFlutterIntlArbFiles(context, value);
                          });
                        },
                      ),
                    ],
                    child: const Icon(
                      CupertinoIcons.add_circled_solid,
                      size: 18,
                    ),
                    builder: (BuildContext context, MenuController controller,
                        Widget? child) {
                      return CupertinoButton(
                        onPressed: () {
                          controller.isOpen
                              ? controller.close()
                              : controller.open();
                        },
                        child: child!,
                      );
                    },
                  ),
                  // ContextMenuRegion(
                  //   menuItems: [
                  //     MenuItem(
                  //       title: "Import Arb Files",
                  //       onSelected: () {
                  //         pickFiles(context).then((value) {
                  //           if (value.isEmpty) {
                  //             return;
                  //           }
                  //           context
                  //               .read<AppLocalizationsCubit>()
                  //               .importFlutterIntlArbFiles(context, value);
                  //         });
                  //       },
                  //     ),
                  //     MenuItem(title: "Add Language"),
                  //   ],
                  //   child: Container(
                  //     padding: const EdgeInsets.all(8),
                  //     child: const Icon(
                  //       CupertinoIcons.add_circled_solid,
                  //       size: 18,
                  //     ),
                  //   ),
                  //   onItemSelected: (item) {
                  //     item.onSelected?.call();
                  //   },
                  // ),
                  const Spacer(),
                  CupertinoButton(
                    child: const Icon(
                      Icons.download,
                      size: 18,
                    ),
                    onPressed: () {
                      context.read<AppLocalizationsCubit>().export(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
