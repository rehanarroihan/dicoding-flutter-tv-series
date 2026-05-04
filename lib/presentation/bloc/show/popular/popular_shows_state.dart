part of 'popular_shows_bloc.dart';

abstract class PopularShowsState extends Equatable {
  const PopularShowsState();

  @override
  List<Object> get props => [];
}

class PopularShowsEmpty extends PopularShowsState {}

class PopularShowsLoading extends PopularShowsState {}

class PopularShowsError extends PopularShowsState {
  final String message;

  const PopularShowsError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularShowsHasData extends PopularShowsState {
  final List<TvShow> result;

  const PopularShowsHasData(this.result);

  @override
  List<Object> get props => [result];
}
