part of 'show_detail_bloc.dart';

enum ShowDataState { empty, loading, loaded, error }

class ShowDetailState extends Equatable {
  final TvShowDetail? showDetail;
  final ShowDataState showDetailState;
  final List<TvShow> showRecommendations;
  final ShowDataState showRecommendationsState;
  final bool isAddedToWatchlist;
  final String message;
  final String watchlistMessage;

  const ShowDetailState({
    required this.showDetail,
    required this.showDetailState,
    required this.showRecommendations,
    required this.showRecommendationsState,
    required this.isAddedToWatchlist,
    required this.message,
    required this.watchlistMessage,
  });

  factory ShowDetailState.initial() {
    return const ShowDetailState(
      showDetail: null,
      showDetailState: ShowDataState.empty,
      showRecommendations: [],
      showRecommendationsState: ShowDataState.empty,
      isAddedToWatchlist: false,
      message: '',
      watchlistMessage: '',
    );
  }

  ShowDetailState copyWith({
    TvShowDetail? showDetail,
    ShowDataState? showDetailState,
    List<TvShow>? showRecommendations,
    ShowDataState? showRecommendationsState,
    bool? isAddedToWatchlist,
    String? message,
    String? watchlistMessage,
  }) {
    return ShowDetailState(
      showDetail: showDetail ?? this.showDetail,
      showDetailState: showDetailState ?? this.showDetailState,
      showRecommendations: showRecommendations ?? this.showRecommendations,
      showRecommendationsState:
          showRecommendationsState ?? this.showRecommendationsState,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        showDetail,
        showDetailState,
        showRecommendations,
        showRecommendationsState,
        isAddedToWatchlist,
        message,
        watchlistMessage,
      ];
}
