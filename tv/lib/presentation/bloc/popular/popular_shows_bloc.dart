import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/usecases/get_popular_shows.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'popular_shows_event.dart';

part 'popular_shows_state.dart';

class PopularShowsBloc extends Bloc<PopularShowsEvent, PopularShowsState> {
  final GetPopularShows _getPopularShows;

  PopularShowsBloc(this._getPopularShows) : super(PopularShowsEmpty()) {
    on<OnFetchPopularShows>((event, emit) async {
      emit(PopularShowsLoading());
      final result = await _getPopularShows.execute();

      result.fold(
        (failure) {
          emit(PopularShowsError(failure.message));
        },
        (data) {
          emit(PopularShowsHasData(data));
        },
      );
    });
  }
}
