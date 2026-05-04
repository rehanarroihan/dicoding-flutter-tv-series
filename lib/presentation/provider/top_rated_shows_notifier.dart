import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_top_rated_shows.dart';
import 'package:flutter/material.dart';

class TopRatedShowsNotifier extends ChangeNotifier {
  final GetTopRatedShows getTopRated;

  TopRatedShowsNotifier(this.getTopRated);

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<TvShow> _list = [];

  List<TvShow> get list => _list;

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  Future<void> fetchTopRated() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTopRated.execute();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _list = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
