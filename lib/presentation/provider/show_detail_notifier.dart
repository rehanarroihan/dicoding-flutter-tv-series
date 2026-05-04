import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:ditonton/domain/usecases/get_show_detail.dart';
import 'package:ditonton/domain/usecases/get_show_recommendations.dart';
import 'package:ditonton/domain/usecases/get_show_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_from_watchlist.dart';
import 'package:ditonton/domain/usecases/save_to_watchlist.dart';
import 'package:flutter/material.dart';

class ShowDetailNotifier extends ChangeNotifier {
  static const addMsg = 'Added to Watchlist';
  static const removeMsg = 'Removed from Watchlist';

  final GetShowDetail getDetail;
  final GetShowRecommendations getRecs;
  final GetShowWatchlistStatus getStatus;
  final SaveToWatchlist saveWatchlist;
  final RemoveFromWatchlist removeWatchlist;

  ShowDetailNotifier({
    required this.getDetail,
    required this.getRecs,
    required this.getStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });

  late TvShowDetail _item;

  TvShowDetail get item => _item;

  List<TvShow> _recs = [];

  List<TvShow> get recs => _recs;

  RequestState _itemStatus = RequestState.Empty;

  RequestState get itemStatus => _itemStatus;

  RequestState _recStatus = RequestState.Empty;

  RequestState get recStatus => _recStatus;

  String _msg = '';

  String get msg => _msg;

  String _watchMsg = '';

  String get watchMsg => _watchMsg;

  bool _inWatchlist = false;

  bool get inWatchlist => _inWatchlist;

  Future<void> fetchDetail(int id) async {
    _itemStatus = RequestState.Loading;
    notifyListeners();

    final detailResult = await getDetail.execute(id);
    final recResult = await getRecs.execute(id);

    detailResult.fold(
      (failure) {
        _itemStatus = RequestState.Error;
        _msg = failure.message;
        notifyListeners();
      },
      (data) {
        _recStatus = RequestState.Loading;
        _item = data;
        notifyListeners();

        recResult.fold(
          (failure) {
            _recStatus = RequestState.Error;
            _msg = failure.message;
          },
          (recsData) {
            _recStatus = RequestState.Loaded;
            _recs = recsData;
          },
        );
        _itemStatus = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> addToWatchlist(TvShowDetail show) async {
    final result = await saveWatchlist.execute(show);

    result.fold(
      (failure) {
        _watchMsg = failure.message;
      },
      (success) {
        _watchMsg = success;
      },
    );

    await refreshWatchlistStatus(show.id);
  }

  Future<void> removeFromWatchlist(TvShowDetail show) async {
    final result = await removeWatchlist.execute(show);

    result.fold(
      (failure) {
        _watchMsg = failure.message;
      },
      (success) {
        _watchMsg = success;
      },
    );

    await refreshWatchlistStatus(show.id);
  }

  Future<void> refreshWatchlistStatus(int id) async {
    final result = await getStatus.execute(id);
    _inWatchlist = result;
    notifyListeners();
  }
}
