import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_top_rated_shows.dart';
import 'package:ditonton/presentation/bloc/show/top_rated/top_rated_shows_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_shows_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedShows])
void main() {
  late TopRatedShowsBloc topRatedShowsBloc;
  late MockGetTopRatedShows mockGetTopRatedShows;

  setUp(() {
    mockGetTopRatedShows = MockGetTopRatedShows();
    topRatedShowsBloc = TopRatedShowsBloc(mockGetTopRatedShows);
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
    expect(topRatedShowsBloc.state, TopRatedShowsEmpty());
  });

  blocTest<TopRatedShowsBloc, TopRatedShowsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedShows.execute())
          .thenAnswer((_) async => Right(tShowList));
      return topRatedShowsBloc;
    },
    act: (bloc) => bloc.add(OnFetchTopRatedShows()),
    expect: () => [
      TopRatedShowsLoading(),
      TopRatedShowsHasData(tShowList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedShows.execute());
    },
  );

  blocTest<TopRatedShowsBloc, TopRatedShowsState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetTopRatedShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedShowsBloc;
    },
    act: (bloc) => bloc.add(OnFetchTopRatedShows()),
    expect: () => [
      TopRatedShowsLoading(),
      TopRatedShowsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedShows.execute());
    },
  );
}
