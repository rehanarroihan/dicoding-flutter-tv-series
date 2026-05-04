import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie/detail/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    movieDetailBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  final tId = 1;
  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  test('initial state should be initial', () {
    expect(movieDetailBloc.state, MovieDetailState.initial());
  });

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, Loaded] when detail and recommendations are gotten successfully',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(OnFetchMovieDetail(tId)),
    expect: () => [
      MovieDetailState.initial()
          .copyWith(movieDetailState: MovieDataState.loading),
      MovieDetailState.initial().copyWith(
        movieDetailState: MovieDataState.loaded,
        movieDetail: testMovieDetail,
        movieRecommendationsState: MovieDataState.loading,
      ),
      MovieDetailState.initial().copyWith(
        movieDetailState: MovieDataState.loaded,
        movieDetail: testMovieDetail,
        movieRecommendationsState: MovieDataState.loaded,
        movieRecommendations: tMovies,
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, Error] when get detail is unsuccessful',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(OnFetchMovieDetail(tId)),
    expect: () => [
      MovieDetailState.initial()
          .copyWith(movieDetailState: MovieDataState.loading),
      MovieDetailState.initial().copyWith(
        movieDetailState: MovieDataState.error,
        message: 'Server Failure',
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit isAddedToWatchlist true when status is gotten successfully',
    build: () {
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(OnLoadWatchlistStatus(tId)),
    expect: () => [
      MovieDetailState.initial().copyWith(isAddedToWatchlist: true),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit watchlistMessage when add watchlist is successful',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => true);
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(OnAddWatchlist(testMovieDetail)),
    expect: () => [
      MovieDetailState.initial()
          .copyWith(watchlistMessage: 'Added to Watchlist'),
      MovieDetailState.initial().copyWith(
        watchlistMessage: 'Added to Watchlist',
        isAddedToWatchlist: true,
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit watchlistMessage when add watchlist is unsuccessful',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(OnAddWatchlist(testMovieDetail)),
    expect: () => [
      MovieDetailState.initial().copyWith(watchlistMessage: 'Failed'),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit watchlistMessage when remove watchlist is successful',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(OnRemoveFromWatchlist(testMovieDetail)),
    expect: () => [
      MovieDetailState.initial()
          .copyWith(watchlistMessage: 'Removed from Watchlist'),
    ],
  );
}
