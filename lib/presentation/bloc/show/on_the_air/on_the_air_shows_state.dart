part of 'on_the_air_shows_bloc.dart';

abstract class OnTheAirShowsState extends Equatable {
  const OnTheAirShowsState();

  @override
  List<Object> get props => [];
}

class OnTheAirShowsEmpty extends OnTheAirShowsState {}

class OnTheAirShowsLoading extends OnTheAirShowsState {}

class OnTheAirShowsError extends OnTheAirShowsState {
  final String message;

  const OnTheAirShowsError(this.message);

  @override
  List<Object> get props => [message];
}

class OnTheAirShowsHasData extends OnTheAirShowsState {
  final List<TvShow> result;

  const OnTheAirShowsHasData(this.result);

  @override
  List<Object> get props => [result];
}
