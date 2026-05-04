import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_popular_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularShows usecase;
  late MockTvShowRepository mockRepo;

  setUp(() {
    mockRepo = MockTvShowRepository();
    usecase = GetPopularShows(mockRepo);
  });

  test('should get list of shows from repository', () async {
    // arrange
    when(mockRepo.fetchPopularShows())
        .thenAnswer((_) async => Right(testShowList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testShowList));
  });
}
