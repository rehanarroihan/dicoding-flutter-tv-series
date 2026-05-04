part of 'show_search_bloc.dart';

abstract class ShowSearchEvent extends Equatable {
  const ShowSearchEvent();

  @override
  List<Object> get props => [];
}

class OnShowSearchQueryChanged extends ShowSearchEvent {
  final String query;

  const OnShowSearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
