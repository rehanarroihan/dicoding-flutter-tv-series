import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/usecases/get_show_detail.dart';
import 'package:core/domain/usecases/get_show_recommendations.dart';
import 'package:core/domain/usecases/get_show_watchlist_status.dart';
import 'package:core/domain/usecases/remove_from_watchlist.dart';
import 'package:core/domain/usecases/save_to_watchlist.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/detail/show_detail_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'show_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetShowDetail,
  GetShowRecommendations,
  GetShowWatchlistStatus,
  SaveToWatchlist,
  RemoveFromWatchlist,
])
void main() {
  late ShowDetailBloc showDetailBloc;
  late MockGetShowDetail mockGetShowDetail;
  late MockGetShowRecommendations mockGetShowRecommendations;
  late MockGetShowWatchlistStatus mockGetShowWatchlistStatus;
  late MockSaveToWatchlist mockSaveToWatchlist;
  late MockRemoveFromWatchlist mockRemoveFromWatchlist;

  setUp(() {
    mockGetShowDetail = MockGetShowDetail();
    mockGetShowRecommendations = MockGetShowRecommendations();
    mockGetShowWatchlistStatus = MockGetShowWatchlistStatus();
    mockSaveToWatchlist = MockSaveToWatchlist();
    mockRemoveFromWatchlist = MockRemoveFromWatchlist();
    showDetailBloc = ShowDetailBloc(
      getShowDetail: mockGetShowDetail,
      getShowRecommendations: mockGetShowRecommendations,
      getShowWatchlistStatus: mockGetShowWatchlistStatus,
      saveToWatchlist: mockSaveToWatchlist,
      removeFromWatchlist: mockRemoveFromWatchlist,
    );
  });

  final tId = 1;
  final tShow = TvShow(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    airDate: 'releaseDate',
    name: 'title',
    rating: 1,
    ratingCount: 1,
  );
  final tShows = <TvShow>[tShow];

  test('initial state should be initial', () {
    expect(showDetailBloc.state, ShowDetailState.initial());
  });

  test('events support equatable props', () {
    expect(const OnFetchShowDetail(1).props, [1]);
    expect(const OnLoadShowWatchlistStatus(1).props, [1]);
    expect(OnAddShowWatchlist(testShowDetail).props, [testShowDetail]);
    expect(OnRemoveShowFromWatchlist(testShowDetail).props, [testShowDetail]);
  });

  blocTest<ShowDetailBloc, ShowDetailState>(
    'Should emit [Loading, Loaded] when detail and recommendations are gotten successfully',
    build: () {
      when(mockGetShowDetail.execute(tId))
          .thenAnswer((_) async => Right(testShowDetail));
      when(mockGetShowRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tShows));
      return showDetailBloc;
    },
    act: (bloc) => bloc.add(OnFetchShowDetail(tId)),
    expect: () => [
      ShowDetailState.initial()
          .copyWith(showDetailState: ShowDataState.loading),
      ShowDetailState.initial().copyWith(
        showDetailState: ShowDataState.loaded,
        showDetail: testShowDetail,
        showRecommendationsState: ShowDataState.loading,
      ),
      ShowDetailState.initial().copyWith(
        showDetailState: ShowDataState.loaded,
        showDetail: testShowDetail,
        showRecommendationsState: ShowDataState.loaded,
        showRecommendations: tShows,
      ),
    ],
  );

  blocTest<ShowDetailBloc, ShowDetailState>(
    'Should emit [Loading, Error] when get detail is unsuccessful',
    build: () {
      when(mockGetShowDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetShowRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tShows));
      return showDetailBloc;
    },
    act: (bloc) => bloc.add(OnFetchShowDetail(tId)),
    expect: () => [
      ShowDetailState.initial()
          .copyWith(showDetailState: ShowDataState.loading),
      ShowDetailState.initial().copyWith(
        showDetailState: ShowDataState.error,
        message: 'Server Failure',
      ),
    ],
  );

  blocTest<ShowDetailBloc, ShowDetailState>(
    'Should emit isAddedToWatchlist true when status is gotten successfully',
    build: () {
      when(mockGetShowWatchlistStatus.execute(tId))
          .thenAnswer((_) async => true);
      return showDetailBloc;
    },
    act: (bloc) => bloc.add(OnLoadShowWatchlistStatus(tId)),
    expect: () => [
      ShowDetailState.initial().copyWith(isAddedToWatchlist: true),
    ],
  );

  blocTest<ShowDetailBloc, ShowDetailState>(
    'Should emit watchlistMessage when add watchlist is successful',
    build: () {
      when(mockSaveToWatchlist.execute(testShowDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      when(mockGetShowWatchlistStatus.execute(testShowDetail.id))
          .thenAnswer((_) async => true);
      return showDetailBloc;
    },
    act: (bloc) => bloc.add(OnAddShowWatchlist(testShowDetail)),
    expect: () => [
      ShowDetailState.initial()
          .copyWith(watchlistMessage: 'Added to Watchlist'),
      ShowDetailState.initial().copyWith(
        watchlistMessage: 'Added to Watchlist',
        isAddedToWatchlist: true,
      ),
    ],
  );

  blocTest<ShowDetailBloc, ShowDetailState>(
    'Should emit watchlistMessage when add watchlist is unsuccessful',
    build: () {
      when(mockSaveToWatchlist.execute(testShowDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetShowWatchlistStatus.execute(testShowDetail.id))
          .thenAnswer((_) async => false);
      return showDetailBloc;
    },
    act: (bloc) => bloc.add(OnAddShowWatchlist(testShowDetail)),
    expect: () => [
      ShowDetailState.initial().copyWith(watchlistMessage: 'Failed'),
    ],
  );

  blocTest<ShowDetailBloc, ShowDetailState>(
    'Should emit [ShowDataState.error] when recommendations are gotten unsuccessfully',
    build: () {
      when(mockGetShowDetail.execute(tId))
          .thenAnswer((_) async => Right(testShowDetail));
      when(mockGetShowRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return showDetailBloc;
    },
    act: (bloc) => bloc.add(OnFetchShowDetail(tId)),
    expect: () => [
      ShowDetailState.initial()
          .copyWith(showDetailState: ShowDataState.loading),
      ShowDetailState.initial().copyWith(
        showDetailState: ShowDataState.loaded,
        showDetail: testShowDetail,
        showRecommendationsState: ShowDataState.loading,
      ),
      ShowDetailState.initial().copyWith(
        showDetailState: ShowDataState.loaded,
        showDetail: testShowDetail,
        showRecommendationsState: ShowDataState.error,
        message: 'Server Failure',
      ),
    ],
  );

  blocTest<ShowDetailBloc, ShowDetailState>(
    'Should emit watchlistMessage when remove watchlist is successful',
    build: () {
      when(mockRemoveFromWatchlist.execute(testShowDetail))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(mockGetShowWatchlistStatus.execute(testShowDetail.id))
          .thenAnswer((_) async => false);
      return showDetailBloc;
    },
    act: (bloc) => bloc.add(OnRemoveShowFromWatchlist(testShowDetail)),
    expect: () => [
      ShowDetailState.initial()
          .copyWith(watchlistMessage: 'Removed from Watchlist'),
    ],
  );

  blocTest<ShowDetailBloc, ShowDetailState>(
    'Should emit watchlistMessage when remove watchlist is unsuccessful',
    build: () {
      when(mockRemoveFromWatchlist.execute(testShowDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetShowWatchlistStatus.execute(testShowDetail.id))
          .thenAnswer((_) async => true);
      return showDetailBloc;
    },
    act: (bloc) => bloc.add(OnRemoveShowFromWatchlist(testShowDetail)),
    expect: () => [
      ShowDetailState.initial().copyWith(watchlistMessage: 'Failed'),
      ShowDetailState.initial().copyWith(
        watchlistMessage: 'Failed',
        isAddedToWatchlist: true,
      ),
    ],
  );
}
