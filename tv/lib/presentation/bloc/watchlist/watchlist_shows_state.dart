part of 'watchlist_shows_bloc.dart';

abstract class WatchlistShowsState extends Equatable {
  const WatchlistShowsState();

  @override
  List<Object> get props => [];
}

class WatchlistShowsEmpty extends WatchlistShowsState {}

class WatchlistShowsLoading extends WatchlistShowsState {}

class WatchlistShowsError extends WatchlistShowsState {
  final String message;

  const WatchlistShowsError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistShowsHasData extends WatchlistShowsState {
  final List<TvShow> result;

  const WatchlistShowsHasData(this.result);

  @override
  List<Object> get props => [result];
}
