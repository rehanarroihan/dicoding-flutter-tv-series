import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_show_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetShowDetail usecase;
  late MockTvShowRepository mockRepo;

  setUp(() {
    mockRepo = MockTvShowRepository();
    usecase = GetShowDetail(mockRepo);
  });

  const tId = 1399;

  test('should get show detail from repository', () async {
    // arrange
    when(mockRepo.fetchShowDetail(tId))
        .thenAnswer((_) async => Right(testShowDetail));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(testShowDetail));
  });
}
