part of 'top_rated_shows_bloc.dart';

abstract class TopRatedShowsEvent extends Equatable {
  const TopRatedShowsEvent();

  @override
  List<Object> get props => [];
}

class OnFetchTopRatedShows extends TopRatedShowsEvent {}
