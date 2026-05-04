import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetOnTheAirShows usecase;
  late MockTvShowRepository mockRepo;

  setUp(() {
    mockRepo = MockTvShowRepository();
    usecase = GetOnTheAirShows(mockRepo);
  });

  test('should get currently airing shows from repository', () async {
    // arrange
    when(mockRepo.fetchOnTheAirShows())
        .thenAnswer((_) async => Right(testShowList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testShowList));
  });
}
