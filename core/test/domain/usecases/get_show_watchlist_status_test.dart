import 'package:core/domain/usecases/get_show_watchlist_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetShowWatchlistStatus usecase;
  late MockTvShowRepository mockRepo;

  setUp(() {
    mockRepo = MockTvShowRepository();
    usecase = GetShowWatchlistStatus(mockRepo);
  });

  const tId = 1399;

  test('should get show watchlist status from repository', () async {
    // arrange
    when(mockRepo.isAddedToWatchlist(tId)).thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, true);
  });
}
