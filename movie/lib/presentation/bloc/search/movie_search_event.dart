part of 'movie_search_bloc.dart';

abstract class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();

  @override
  List<Object> get props => [];
}

class OnMovieSearchQueryChanged extends MovieSearchEvent {
  final String query;

  const OnMovieSearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
