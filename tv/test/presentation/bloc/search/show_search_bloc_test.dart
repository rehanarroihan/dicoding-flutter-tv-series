import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/usecases/search_shows.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/search/show_search_bloc.dart';

import 'show_search_bloc_test.mocks.dart';

@GenerateMocks([SearchShows])
void main() {
  late ShowSearchBloc showSearchBloc;
  late MockSearchShows mockSearchShows;

  setUp(() {
    mockSearchShows = MockSearchShows();
    showSearchBloc = ShowSearchBloc(mockSearchShows);
  });

  final tShowModel = TvShow(
    backdropPath: '/muth49D0unO7Pnc9WreP9NfP9Y8.jpg',
    genreIds: [14, 28],
    id: 557,
    originalName: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43T20lgmCUvo0p4uRgy.jpg',
    airDate: '2002-05-01',
    name: 'Spider-Man',
    rating: 7.2,
    ratingCount: 13507,
  );
  final tShowList = <TvShow>[tShowModel];
  final tQuery = 'spiderman';

  test('initial state should be empty', () {
    expect(showSearchBloc.state, ShowSearchEmpty());
  });

  test('event and states support equatable props', () {
    expect(const OnShowSearchQueryChanged('q').props, ['q']);
    expect(const ShowSearchError('m').props, ['m']);
    expect(const ShowSearchHasData([]).props, [
      const <TvShow>[],
    ]);
    expect(ShowSearchLoading().props, []);
    expect(ShowSearchEmpty().props, []);
  });

  test('debounce returns an EventTransformer', () {
    final transformer =
        showSearchBloc.debounce<OnShowSearchQueryChanged>(Duration.zero);
    expect(transformer, isA<EventTransformer<OnShowSearchQueryChanged>>());
  });

  blocTest<ShowSearchBloc, ShowSearchState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchShows.execute(tQuery))
          .thenAnswer((_) async => Right(tShowList));
      return showSearchBloc;
    },
    act: (bloc) => bloc.add(OnShowSearchQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      ShowSearchLoading(),
      ShowSearchHasData(tShowList),
    ],
    verify: (bloc) {
      verify(mockSearchShows.execute(tQuery));
    },
  );

  blocTest<ShowSearchBloc, ShowSearchState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchShows.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return showSearchBloc;
    },
    act: (bloc) => bloc.add(OnShowSearchQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      ShowSearchLoading(),
      const ShowSearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchShows.execute(tQuery));
    },
  );
}
