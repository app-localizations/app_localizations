part of 'filter_and_sort_cubit.dart';

class FilterAndSortState extends Equatable {
  const FilterAndSortState({
    this.filter = "",
    this.sortBy = AppLocalizationSortBy.key,
  });

  final String filter;
  final AppLocalizationSortBy sortBy;

  @override
  List<Object> get props => [
        filter,
        sortBy.index,
      ];

  FilterAndSortState copyWith({
    String? filter,
    AppLocalizationSortBy? sortBy,
  }) {
    return FilterAndSortState(
      filter: filter ?? this.filter,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

enum AppLocalizationSortBy {
  key,
  source,
  value,
  comment,
  state,
}
