import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/search_movies.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/search/movie_search_bloc.dart';

import 'movie_search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MovieSearchBloc movieSearchBloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    movieSearchBloc = MovieSearchBloc(mockSearchMovies);
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth49D0unO7Pnc9WreP9NfP9Y8.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43T20lgmCUvo0p4uRgy.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];
  final tQuery = 'spiderman';

  test('initial state should be empty', () {
    expect(movieSearchBloc.state, MovieSearchEmpty());
  });

  test('event and states support equatable props', () {
    expect(const OnMovieSearchQueryChanged('q').props, ['q']);
    expect(const MovieSearchError('m').props, ['m']);
    expect(const MovieSearchHasData([]).props, [
      const <Movie>[],
    ]);
    expect(MovieSearchLoading().props, []);
    expect(MovieSearchEmpty().props, []);
  });

  test('debounce returns an EventTransformer', () {
    final transformer =
        movieSearchBloc.debounce<OnMovieSearchQueryChanged>(Duration.zero);
    expect(transformer, isA<EventTransformer<OnMovieSearchQueryChanged>>());
  });

  blocTest<MovieSearchBloc, MovieSearchState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      return movieSearchBloc;
    },
    act: (bloc) => bloc.add(OnMovieSearchQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      MovieSearchLoading(),
      MovieSearchHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );

  blocTest<MovieSearchBloc, MovieSearchState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieSearchBloc;
    },
    act: (bloc) => bloc.add(OnMovieSearchQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      MovieSearchLoading(),
      const MovieSearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );

  blocTest<MovieSearchBloc, MovieSearchState>(
    'Should emit [Loading, Empty] when data is empty',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => const Right([]));
      return movieSearchBloc;
    },
    act: (bloc) => bloc.add(OnMovieSearchQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      MovieSearchLoading(),
      const MovieSearchHasData([]),
    ],
  );
}
