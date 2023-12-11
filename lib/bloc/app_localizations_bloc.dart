import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_localizations_event.dart';
part 'app_localizations_state.dart';

class AppLocalizationsBloc
    extends Bloc<AppLocalizationsEvent, AppLocalizationsState> {
  AppLocalizationsBloc() : super(AppLocalizationsInitial()) {
    on<AppLocalizationsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
