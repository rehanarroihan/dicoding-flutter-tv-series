import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_showing_tv_series.dart';
import 'package:flutter/foundation.dart';

class NowShowingTvSeriesNotifier extends ChangeNotifier {
  final GetNowShowingTvSeries getNowShowingTvSeries;

  NowShowingTvSeriesNotifier({required this.getNowShowingTvSeries});

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<TvSeries> _series = [];

  List<TvSeries> get series => _series;

  String _message = '';

  String get message => _message;

  Future<void> fetchShowingTvSeries() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getNowShowingTvSeries.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvSeriesData) {
        _series = tvSeriesData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
