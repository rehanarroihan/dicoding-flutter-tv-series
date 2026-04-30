import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_showing_tv_series.dart';
import 'package:ditonton/presentation/provider/now_showing_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_showing_tv_series_notifier_test.mocks.dart';

@GenerateMocks([GetNowShowingTvSeries])
void main() {
  late MockGetNowShowingTvSeries mockGetNowShowingTvSeries;
  late NowShowingTvSeriesNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowShowingTvSeries = MockGetNowShowingTvSeries();
    notifier = NowShowingTvSeriesNotifier(
        getNowShowingTvSeries: mockGetNowShowingTvSeries)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  final tTvSeries = TvSeries(
    firstAirDate: '321',
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'TV Series A',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    originCountry: ['id'],
    originalLanguage: 'id',
    originalName: 'tvseriesa,',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvSeriesList = <TvSeries>[tTvSeries];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetNowShowingTvSeries.execute())
        .thenAnswer((_) async => Right(tTvSeriesList));
    // act
    notifier.fetchShowingTvSeries();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change tv series data when data is gotten successfully',
      () async {
    // arrange
    when(mockGetNowShowingTvSeries.execute())
        .thenAnswer((_) async => Right(tTvSeriesList));
    // act
    await notifier.fetchShowingTvSeries();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.series, tTvSeriesList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetNowShowingTvSeries.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchShowingTvSeries();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
