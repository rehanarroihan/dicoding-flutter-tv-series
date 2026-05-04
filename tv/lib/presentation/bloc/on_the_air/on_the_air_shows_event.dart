part of 'on_the_air_shows_bloc.dart';

abstract class OnTheAirShowsEvent extends Equatable {
  const OnTheAirShowsEvent();

  @override
  List<Object> get props => [];
}

class OnFetchOnTheAirShows extends OnTheAirShowsEvent {}
