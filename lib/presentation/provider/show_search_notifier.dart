import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/search_shows.dart';
import 'package:flutter/material.dart';

class ShowSearchNotifier extends ChangeNotifier {
  final SearchShows searchShows;

  ShowSearchNotifier(this.searchShows);

  RequestState _searchStatus = RequestState.Empty;

  RequestState get searchStatus => _searchStatus;

  List<TvShow> _results = [];

  List<TvShow> get results => _results;

  String _info = '';

  String get info => _info;

  Future<void> executeSearch(String query) async {
    _searchStatus = RequestState.Loading;
    notifyListeners();

    final response = await searchShows.execute(query);

    response.fold(
      (failure) {
        _info = failure.message;
        _searchStatus = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _results = data;
        _searchStatus = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
