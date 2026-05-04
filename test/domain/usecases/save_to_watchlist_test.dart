import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/save_to_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveToWatchlist usecase;
  late MockTvShowRepository mockRepo;

  setUp(() {
    mockRepo = MockTvShowRepository();
    usecase = SaveToWatchlist(mockRepo);
  });

  test('should save show to watchlist', () async {
    // arrange
    when(mockRepo.addWatchlist(testShowDetail))
        .thenAnswer((_) async => const Right('Added'));
    // act
    final result = await usecase.execute(testShowDetail);
    // assert
    expect(result, const Right('Added'));
  });
}
