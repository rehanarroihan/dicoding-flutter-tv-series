import 'package:core/domain/usecases/get_top_rated_shows.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedShows usecase;
  late MockTvShowRepository mockRepo;

  setUp(() {
    mockRepo = MockTvShowRepository();
    usecase = GetTopRatedShows(mockRepo);
  });

  test('should get top rated shows from repository', () async {
    // arrange
    when(mockRepo.fetchTopRatedShows())
        .thenAnswer((_) async => Right(testShowList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testShowList));
  });
}
