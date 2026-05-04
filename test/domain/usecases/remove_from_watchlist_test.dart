import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/remove_from_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveFromWatchlist usecase;
  late MockTvShowRepository mockRepo;

  setUp(() {
    mockRepo = MockTvShowRepository();
    usecase = RemoveFromWatchlist(mockRepo);
  });

  test('should remove show from watchlist', () async {
    // arrange
    when(mockRepo.removeWatchlist(testShowDetail))
        .thenAnswer((_) async => const Right('Removed'));
    // act
    final result = await usecase.execute(testShowDetail);
    // assert
    expect(result, const Right('Removed'));
  });
}
