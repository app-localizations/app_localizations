import 'package:app_localizations/cubit/filter_and_sort_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLocalizationsSearchBar extends StatelessWidget {
  const AppLocalizationsSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FilterAndSortCubit>();

    final controller = TextEditingController(text: cubit.state.filter);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      // child: TextField(
      //   controller: controller,
      //   decoration: InputDecoration(
      //     hintText: "Filter",
      //     border: OutlineInputBorder(
      //       borderRadius: BorderRadius.circular(8),
      //     ),
      //   ),
      //   cursorHeight: 14,
      //   onChanged: (value) {
      //     cubit.setFilter(value);
      //   },
      // ),
      child: CupertinoSearchTextField(
        controller: controller,
        onChanged: (value) {
          cubit.setFilter(value);
        },
      ),
    );
  }
}
