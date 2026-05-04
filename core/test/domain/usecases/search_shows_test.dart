import 'package:core/domain/usecases/search_shows.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchShows usecase;
  late MockTvShowRepository mockRepo;

  setUp(() {
    mockRepo = MockTvShowRepository();
    usecase = SearchShows(mockRepo);
  });

  const tQuery = 'game';

  test('should search shows from repository', () async {
    // arrange
    when(mockRepo.findShows(tQuery))
        .thenAnswer((_) async => Right(testShowList));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(testShowList));
  });
}
