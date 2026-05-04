import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_popular_shows.dart';
import 'package:flutter/material.dart';

class PopularShowsNotifier extends ChangeNotifier {
  final GetPopularShows getPopular;

  PopularShowsNotifier(this.getPopular);

  RequestState _reqState = RequestState.Empty;

  RequestState get reqState => _reqState;

  List<TvShow> _items = [];

  List<TvShow> get items => _items;

  String _errMsg = '';

  String get errMsg => _errMsg;

  Future<void> loadPopularShows() async {
    _reqState = RequestState.Loading;
    notifyListeners();

    final response = await getPopular.execute();

    response.fold(
      (err) {
        _errMsg = err.message;
        _reqState = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _items = data;
        _reqState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
