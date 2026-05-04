import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_top_rated_shows.dart';
import 'package:ditonton/presentation/provider/top_rated_shows_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_shows_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedShows])
void main() {
  late MockGetTopRatedShows mockGetTopRated;
  late TopRatedShowsNotifier notifier;
  late int callCount;

  setUp(() {
    callCount = 0;
    mockGetTopRated = MockGetTopRatedShows();
    notifier = TopRatedShowsNotifier(mockGetTopRated)
      ..addListener(() {
        callCount++;
      });
  });

  test('should initiate loading when fetching top rated shows', () async {
    // arrange
    when(mockGetTopRated.execute())
        .thenAnswer((_) async => Right(testShowList));
    // act
    notifier.fetchTopRated();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(callCount, 1);
  });

  test('should successfully load top rated shows', () async {
    // arrange
    when(mockGetTopRated.execute())
        .thenAnswer((_) async => Right(testShowList));
    // act
    await notifier.fetchTopRated();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.list, testShowList);
    expect(callCount, 2);
  });

  test('should handle server errors gracefully', () async {
    // arrange
    when(mockGetTopRated.execute())
        .thenAnswer((_) async => Left(ServerFailure('API Error')));
    // act
    await notifier.fetchTopRated();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.errorMessage, 'API Error');
    expect(callCount, 2);
  });
}
