import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_popular_shows.dart';
import 'package:ditonton/presentation/provider/popular_shows_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_shows_notifier_test.mocks.dart';

@GenerateMocks([GetPopularShows])
void main() {
  late MockGetPopularShows mockGetPopular;
  late PopularShowsNotifier notifier;
  late int callCount;

  setUp(() {
    callCount = 0;
    mockGetPopular = MockGetPopularShows();
    notifier = PopularShowsNotifier(mockGetPopular)
      ..addListener(() {
        callCount++;
      });
  });

  test('should update status to loading when fetching data', () async {
    // arrange
    when(mockGetPopular.execute()).thenAnswer((_) async => Right(testShowList));
    // act
    notifier.loadPopularShows();
    // assert
    expect(notifier.reqState, RequestState.Loading);
    expect(callCount, 1);
  });

  test('should populate show list when retrieval is successful', () async {
    // arrange
    when(mockGetPopular.execute()).thenAnswer((_) async => Right(testShowList));
    // act
    await notifier.loadPopularShows();
    // assert
    expect(notifier.reqState, RequestState.Loaded);
    expect(notifier.items, testShowList);
    expect(callCount, 2);
  });

  test('should display error message when retrieval fails', () async {
    // arrange
    when(mockGetPopular.execute())
        .thenAnswer((_) async => Left(ServerFailure('Fetch Failed')));
    // act
    await notifier.loadPopularShows();
    // assert
    expect(notifier.reqState, RequestState.Error);
    expect(notifier.errMsg, 'Fetch Failed');
    expect(callCount, 2);
  });
}
