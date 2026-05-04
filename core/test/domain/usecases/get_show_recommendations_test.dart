import 'package:core/domain/usecases/get_show_recommendations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetShowRecommendations usecase;
  late MockTvShowRepository mockRepo;

  setUp(() {
    mockRepo = MockTvShowRepository();
    usecase = GetShowRecommendations(mockRepo);
  });

  const tId = 1399;

  test('should get show recommendations from repository', () async {
    // arrange
    when(mockRepo.fetchShowRecommendations(tId))
        .thenAnswer((_) async => Right(testShowList));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(testShowList));
  });
}
