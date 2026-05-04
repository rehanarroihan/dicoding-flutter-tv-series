import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_watchlist_shows.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_shows_event.dart';
part 'watchlist_shows_state.dart';

class WatchlistShowsBloc
    extends Bloc<WatchlistShowsEvent, WatchlistShowsState> {
  final GetWatchlistShows _getWatchlistShows;

  WatchlistShowsBloc(this._getWatchlistShows) : super(WatchlistShowsEmpty()) {
    on<OnFetchWatchlistShows>((event, emit) async {
      emit(WatchlistShowsLoading());
      final result = await _getWatchlistShows.execute();

      result.fold(
        (failure) {
          emit(WatchlistShowsError(failure.message));
        },
        (data) {
          emit(WatchlistShowsHasData(data));
        },
      );
    });
  }
}
