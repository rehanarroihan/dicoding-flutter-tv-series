part of 'popular_shows_bloc.dart';

abstract class PopularShowsEvent extends Equatable {
  const PopularShowsEvent();

  @override
  List<Object> get props => [];
}

class OnFetchPopularShows extends PopularShowsEvent {}
