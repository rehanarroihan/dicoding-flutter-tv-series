part of 'show_search_bloc.dart';

abstract class ShowSearchState extends Equatable {
  const ShowSearchState();

  @override
  List<Object> get props => [];
}

class ShowSearchEmpty extends ShowSearchState {}

class ShowSearchLoading extends ShowSearchState {}

class ShowSearchError extends ShowSearchState {
  final String message;

  const ShowSearchError(this.message);

  @override
  List<Object> get props => [message];
}

class ShowSearchHasData extends ShowSearchState {
  final List<TvShow> result;

  const ShowSearchHasData(this.result);

  @override
  List<Object> get props => [result];
}
