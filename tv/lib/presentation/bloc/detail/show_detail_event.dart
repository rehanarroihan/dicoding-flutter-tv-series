part of 'show_detail_bloc.dart';

abstract class ShowDetailEvent extends Equatable {
  const ShowDetailEvent();

  @override
  List<Object> get props => [];
}

class OnFetchShowDetail extends ShowDetailEvent {
  final int id;

  const OnFetchShowDetail(this.id);

  @override
  List<Object> get props => [id];
}

class OnAddShowWatchlist extends ShowDetailEvent {
  final TvShowDetail show;

  const OnAddShowWatchlist(this.show);

  @override
  List<Object> get props => [show];
}

class OnRemoveShowFromWatchlist extends ShowDetailEvent {
  final TvShowDetail show;

  const OnRemoveShowFromWatchlist(this.show);

  @override
  List<Object> get props => [show];
}

class OnLoadShowWatchlistStatus extends ShowDetailEvent {
  final int id;

  const OnLoadShowWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}
