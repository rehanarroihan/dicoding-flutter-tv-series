part of 'movie_detail_bloc.dart';

enum MovieDataState { empty, loading, loaded, error }

class MovieDetailState extends Equatable {
  final MovieDetail? movieDetail;
  final MovieDataState movieDetailState;
  final List<Movie> movieRecommendations;
  final MovieDataState movieRecommendationsState;
  final bool isAddedToWatchlist;
  final String message;
  final String watchlistMessage;

  const MovieDetailState({
    required this.movieDetail,
    required this.movieDetailState,
    required this.movieRecommendations,
    required this.movieRecommendationsState,
    required this.isAddedToWatchlist,
    required this.message,
    required this.watchlistMessage,
  });

  factory MovieDetailState.initial() {
    return const MovieDetailState(
      movieDetail: null,
      movieDetailState: MovieDataState.empty,
      movieRecommendations: [],
      movieRecommendationsState: MovieDataState.empty,
      isAddedToWatchlist: false,
      message: '',
      watchlistMessage: '',
    );
  }

  MovieDetailState copyWith({
    MovieDetail? movieDetail,
    MovieDataState? movieDetailState,
    List<Movie>? movieRecommendations,
    MovieDataState? movieRecommendationsState,
    bool? isAddedToWatchlist,
    String? message,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      movieDetail: movieDetail ?? this.movieDetail,
      movieDetailState: movieDetailState ?? this.movieDetailState,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      movieRecommendationsState:
          movieRecommendationsState ?? this.movieRecommendationsState,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        movieDetail,
        movieDetailState,
        movieRecommendations,
        movieRecommendationsState,
        isAddedToWatchlist,
        message,
        watchlistMessage,
      ];
}
