import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_shows.dart';
import 'package:ditonton/presentation/provider/on_the_air_shows_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'on_the_air_shows_notifier_test.mocks.dart';

@GenerateMocks([GetOnTheAirShows])
void main() {
  late MockGetOnTheAirShows mockGetOnTheAir;
  late OnTheAirShowsNotifier notifier;
  late int listenerCount;

  setUp(() {
    listenerCount = 0;
    mockGetOnTheAir = MockGetOnTheAirShows();
    notifier = OnTheAirShowsNotifier(mockGetOnTheAir)
      ..addListener(() {
        listenerCount++;
      });
  });

  test('should set loading state when fetching data', () async {
    // arrange
    when(mockGetOnTheAir.execute())
        .thenAnswer((_) async => Right(testShowList));
    // act
    notifier.fetchShows();
    // assert
    expect(notifier.status, RequestState.Loading);
    expect(listenerCount, 1);
  });

  test('should update show data on success', () async {
    // arrange
    when(mockGetOnTheAir.execute())
        .thenAnswer((_) async => Right(testShowList));
    // act
    await notifier.fetchShows();
    // assert
    expect(notifier.status, RequestState.Loaded);
    expect(notifier.showList, testShowList);
    expect(listenerCount, 2);
  });

  test('should show error message on failure', () async {
    // arrange
    when(mockGetOnTheAir.execute())
        .thenAnswer((_) async => Left(ServerFailure('Error Occurred')));
    // act
    await notifier.fetchShows();
    // assert
    expect(notifier.status, RequestState.Error);
    expect(notifier.msg, 'Error Occurred');
    expect(listenerCount, 2);
  });
}
