part of 'watchlist_shows_bloc.dart';

abstract class WatchlistShowsEvent extends Equatable {
  const WatchlistShowsEvent();

  @override
  List<Object> get props => [];
}

class OnFetchWatchlistShows extends WatchlistShowsEvent {}
