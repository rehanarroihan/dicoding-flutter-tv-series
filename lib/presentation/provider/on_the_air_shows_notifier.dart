import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_shows.dart';
import 'package:flutter/material.dart';

class OnTheAirShowsNotifier extends ChangeNotifier {
  final GetOnTheAirShows getOnTheAir;

  OnTheAirShowsNotifier(this.getOnTheAir);

  RequestState _status = RequestState.Empty;

  RequestState get status => _status;

  List<TvShow> _showList = [];

  List<TvShow> get showList => _showList;

  String _msg = '';

  String get msg => _msg;

  Future<void> fetchShows() async {
    _status = RequestState.Loading;
    notifyListeners();

    final result = await getOnTheAir.execute();

    result.fold(
      (failure) {
        _msg = failure.message;
        _status = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _showList = data;
        _status = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
