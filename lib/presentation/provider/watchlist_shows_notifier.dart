import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_watchlist_shows.dart';
import 'package:flutter/material.dart';

class WatchlistShowsNotifier extends ChangeNotifier {
  final GetWatchlistShows getWatchlist;

  WatchlistShowsNotifier(this.getWatchlist);

  RequestState _watchlistState = RequestState.Empty;

  RequestState get watchlistState => _watchlistState;

  List<TvShow> _watchlistItems = [];

  List<TvShow> get watchlistItems => _watchlistItems;

  String _err = '';

  String get err => _err;

  Future<void> loadWatchlist() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlist.execute();

    result.fold(
      (failure) {
        _err = failure.message;
        _watchlistState = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _watchlistItems = data;
        _watchlistState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
