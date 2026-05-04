part of 'top_rated_shows_bloc.dart';

abstract class TopRatedShowsState extends Equatable {
  const TopRatedShowsState();

  @override
  List<Object> get props => [];
}

class TopRatedShowsEmpty extends TopRatedShowsState {}

class TopRatedShowsLoading extends TopRatedShowsState {}

class TopRatedShowsError extends TopRatedShowsState {
  final String message;

  const TopRatedShowsError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedShowsHasData extends TopRatedShowsState {
  final List<TvShow> result;

  const TopRatedShowsHasData(this.result);

  @override
  List<Object> get props => [result];
}
