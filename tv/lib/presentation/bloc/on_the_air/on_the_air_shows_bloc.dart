import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/usecases/get_on_the_air_shows.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'on_the_air_shows_event.dart';
part 'on_the_air_shows_state.dart';

class OnTheAirShowsBloc extends Bloc<OnTheAirShowsEvent, OnTheAirShowsState> {
  final GetOnTheAirShows _getOnTheAirShows;

  OnTheAirShowsBloc(this._getOnTheAirShows) : super(OnTheAirShowsEmpty()) {
    on<OnFetchOnTheAirShows>((event, emit) async {
      emit(OnTheAirShowsLoading());
      final result = await _getOnTheAirShows.execute();

      result.fold(
        (failure) {
          emit(OnTheAirShowsError(failure.message));
        },
        (data) {
          emit(OnTheAirShowsHasData(data));
        },
      );
    });
  }
}
