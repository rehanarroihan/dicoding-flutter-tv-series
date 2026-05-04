import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/usecases/get_top_rated_shows.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_rated_shows_event.dart';
part 'top_rated_shows_state.dart';

class TopRatedShowsBloc extends Bloc<TopRatedShowsEvent, TopRatedShowsState> {
  final GetTopRatedShows _getTopRatedShows;

  TopRatedShowsBloc(this._getTopRatedShows) : super(TopRatedShowsEmpty()) {
    on<OnFetchTopRatedShows>((event, emit) async {
      emit(TopRatedShowsLoading());
      final result = await _getTopRatedShows.execute();

      result.fold(
        (failure) {
          emit(TopRatedShowsError(failure.message));
        },
        (data) {
          emit(TopRatedShowsHasData(data));
        },
      );
    });
  }
}
