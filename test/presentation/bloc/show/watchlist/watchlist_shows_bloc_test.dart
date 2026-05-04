import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_watchlist_shows.dart';
import 'package:ditonton/presentation/bloc/show/watchlist/watchlist_shows_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_shows_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistShows])
void main() {
  late WatchlistShowsBloc watchlistShowsBloc;
  late MockGetWatchlistShows mockGetWatchlistShows;

  setUp(() {
    mockGetWatchlistShows = MockGetWatchlistShows();
    watchlistShowsBloc = WatchlistShowsBloc(mockGetWatchlistShows);
  });

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
  final tShowList = <TvShow>[tShow];

  test('initial state should be empty', () {
    expect(watchlistShowsBloc.state, WatchlistShowsEmpty());
  });

  blocTest<WatchlistShowsBloc, WatchlistShowsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistShows.execute())
          .thenAnswer((_) async => Right(tShowList));
      return watchlistShowsBloc;
    },
    act: (bloc) => bloc.add(OnFetchWatchlistShows()),
    expect: () => [
      WatchlistShowsLoading(),
      WatchlistShowsHasData(tShowList),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistShows.execute());
    },
  );

  blocTest<WatchlistShowsBloc, WatchlistShowsState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetWatchlistShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistShowsBloc;
    },
    act: (bloc) => bloc.add(OnFetchWatchlistShows()),
    expect: () => [
      WatchlistShowsLoading(),
      WatchlistShowsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistShows.execute());
    },
  );
}
