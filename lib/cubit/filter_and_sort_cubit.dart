import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_and_sort_state.dart';

class FilterAndSortCubit extends Cubit<FilterAndSortState> {
  FilterAndSortCubit() : super(const FilterAndSortState());

  void setFilter(String value) {
    emit(state.copyWith(filter: value));
  }

  void setSortBy(AppLocalizationSortBy value) {
    emit(state.copyWith(sortBy: value));
  }
}
