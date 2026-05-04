import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_popular_shows.dart';
import 'package:ditonton/presentation/bloc/show/popular/popular_shows_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_shows_bloc_test.mocks.dart';

@GenerateMocks([GetPopularShows])
void main() {
  late PopularShowsBloc popularShowsBloc;
  late MockGetPopularShows mockGetPopularShows;

  setUp(() {
    mockGetPopularShows = MockGetPopularShows();
    popularShowsBloc = PopularShowsBloc(mockGetPopularShows);
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
    expect(popularShowsBloc.state, PopularShowsEmpty());
  });

  blocTest<PopularShowsBloc, PopularShowsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularShows.execute())
          .thenAnswer((_) async => Right(tShowList));
      return popularShowsBloc;
    },
    act: (bloc) => bloc.add(OnFetchPopularShows()),
    expect: () => [
      PopularShowsLoading(),
      PopularShowsHasData(tShowList),
    ],
    verify: (bloc) {
      verify(mockGetPopularShows.execute());
    },
  );

  blocTest<PopularShowsBloc, PopularShowsState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetPopularShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularShowsBloc;
    },
    act: (bloc) => bloc.add(OnFetchPopularShows()),
    expect: () => [
      PopularShowsLoading(),
      PopularShowsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetPopularShows.execute());
    },
  );
}
