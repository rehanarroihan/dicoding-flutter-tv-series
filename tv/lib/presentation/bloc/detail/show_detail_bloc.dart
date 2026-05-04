import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/entities/tv_show_detail.dart';
import 'package:core/domain/usecases/get_show_detail.dart';
import 'package:core/domain/usecases/get_show_recommendations.dart';
import 'package:core/domain/usecases/get_show_watchlist_status.dart';
import 'package:core/domain/usecases/remove_from_watchlist.dart';
import 'package:core/domain/usecases/save_to_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'show_detail_event.dart';
part 'show_detail_state.dart';

class ShowDetailBloc extends Bloc<ShowDetailEvent, ShowDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetShowDetail _getShowDetail;
  final GetShowRecommendations _getShowRecommendations;
  final GetShowWatchlistStatus _getShowWatchlistStatus;
  final SaveToWatchlist _saveToWatchlist;
  final RemoveFromWatchlist _removeFromWatchlist;

  ShowDetailBloc({
    required GetShowDetail getShowDetail,
    required GetShowRecommendations getShowRecommendations,
    required GetShowWatchlistStatus getShowWatchlistStatus,
    required SaveToWatchlist saveToWatchlist,
    required RemoveFromWatchlist removeFromWatchlist,
  })  : _getShowDetail = getShowDetail,
        _getShowRecommendations = getShowRecommendations,
        _getShowWatchlistStatus = getShowWatchlistStatus,
        _saveToWatchlist = saveToWatchlist,
        _removeFromWatchlist = removeFromWatchlist,
        super(ShowDetailState.initial()) {
    on<OnFetchShowDetail>((event, emit) async {
      emit(state.copyWith(showDetailState: ShowDataState.loading));
      final detailResult = await _getShowDetail.execute(event.id);
      final recommendationResult =
          await _getShowRecommendations.execute(event.id);

      detailResult.fold(
        (failure) {
          emit(
            state.copyWith(
              showDetailState: ShowDataState.error,
              message: failure.message,
            ),
          );
        },
        (show) {
          emit(
            state.copyWith(
              showDetailState: ShowDataState.loaded,
              showDetail: show,
              showRecommendationsState: ShowDataState.loading,
              message: '',
            ),
          );
          recommendationResult.fold(
            (failure) {
              emit(
                state.copyWith(
                  showRecommendationsState: ShowDataState.error,
                  message: failure.message,
                ),
              );
            },
            (recommendations) {
              emit(
                state.copyWith(
                  showRecommendationsState: ShowDataState.loaded,
                  showRecommendations: recommendations,
                ),
              );
            },
          );
        },
      );
    });

    on<OnAddShowWatchlist>((event, emit) async {
      final result = await _saveToWatchlist.execute(event.show);

      result.fold(
        (failure) {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );

      add(OnLoadShowWatchlistStatus(event.show.id));
    });

    on<OnRemoveShowFromWatchlist>((event, emit) async {
      final result = await _removeFromWatchlist.execute(event.show);

      result.fold(
        (failure) {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );

      add(OnLoadShowWatchlistStatus(event.show.id));
    });

    on<OnLoadShowWatchlistStatus>((event, emit) async {
      final result = await _getShowWatchlistStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: result));
    });
  }
}
