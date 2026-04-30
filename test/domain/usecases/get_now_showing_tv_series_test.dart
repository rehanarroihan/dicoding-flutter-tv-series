import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_showing_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowShowingTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetNowShowingTvSeries(repository: mockTvSeriesRepository);
  });

  final tvSeries = <TvSeries>[];

  test('get list of TV Series now showing from the repository', () async {
    // arrange
    when(mockTvSeriesRepository.getShowingTvSeries())
        .thenAnswer((_) async => Right(tvSeries));
    //act
    final result = await usecase.execute();
    //assert
    expect(result, Right(tvSeries));
  });
}
