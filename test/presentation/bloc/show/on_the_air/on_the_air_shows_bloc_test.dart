import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_shows.dart';
import 'package:ditonton/presentation/bloc/show/on_the_air/on_the_air_shows_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'on_the_air_shows_bloc_test.mocks.dart';

@GenerateMocks([GetOnTheAirShows])
void main() {
  late OnTheAirShowsBloc onTheAirShowsBloc;
  late MockGetOnTheAirShows mockGetOnTheAirShows;

  setUp(() {
    mockGetOnTheAirShows = MockGetOnTheAirShows();
    onTheAirShowsBloc = OnTheAirShowsBloc(mockGetOnTheAirShows);
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
    expect(onTheAirShowsBloc.state, OnTheAirShowsEmpty());
  });

  blocTest<OnTheAirShowsBloc, OnTheAirShowsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetOnTheAirShows.execute())
          .thenAnswer((_) async => Right(tShowList));
      return onTheAirShowsBloc;
    },
    act: (bloc) => bloc.add(OnFetchOnTheAirShows()),
    expect: () => [
      OnTheAirShowsLoading(),
      OnTheAirShowsHasData(tShowList),
    ],
    verify: (bloc) {
      verify(mockGetOnTheAirShows.execute());
    },
  );

  blocTest<OnTheAirShowsBloc, OnTheAirShowsState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetOnTheAirShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return onTheAirShowsBloc;
    },
    act: (bloc) => bloc.add(OnFetchOnTheAirShows()),
    expect: () => [
      OnTheAirShowsLoading(),
      OnTheAirShowsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetOnTheAirShows.execute());
    },
  );
}
