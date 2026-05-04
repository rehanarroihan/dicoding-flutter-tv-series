import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_show_detail.dart';
import 'package:ditonton/domain/usecases/get_show_recommendations.dart';
import 'package:ditonton/domain/usecases/get_show_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_from_watchlist.dart';
import 'package:ditonton/domain/usecases/save_to_watchlist.dart';
import 'package:ditonton/presentation/provider/show_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'show_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetShowDetail,
  GetShowRecommendations,
  GetShowWatchlistStatus,
  SaveToWatchlist,
  RemoveFromWatchlist,
])
void main() {
  late ShowDetailNotifier notifier;
  late MockGetShowDetail mockGetDetail;
  late MockGetShowRecommendations mockGetRecs;
  late MockGetShowWatchlistStatus mockGetStatus;
  late MockSaveToWatchlist mockSave;
  late MockRemoveFromWatchlist mockRemove;

  setUp(() {
    mockGetDetail = MockGetShowDetail();
    mockGetRecs = MockGetShowRecommendations();
    mockGetStatus = MockGetShowWatchlistStatus();
    mockSave = MockSaveToWatchlist();
    mockRemove = MockRemoveFromWatchlist();
    notifier = ShowDetailNotifier(
      getDetail: mockGetDetail,
      getRecs: mockGetRecs,
      getStatus: mockGetStatus,
      saveWatchlist: mockSave,
      removeWatchlist: mockRemove,
    );
  });

  const tId = 1399;

  group('Get Show Detail', () {
    test('should fetch show detail and recommendations', () async {
      // arrange
      when(mockGetDetail.execute(tId))
          .thenAnswer((_) async => Right(testShowDetail));
      when(mockGetRecs.execute(tId))
          .thenAnswer((_) async => Right(testShowList));
      // act
      await notifier.fetchDetail(tId);
      // assert
      expect(notifier.itemStatus, RequestState.Loaded);
      expect(notifier.item, testShowDetail);
      expect(notifier.recStatus, RequestState.Loaded);
      expect(notifier.recs, testShowList);
    });

    test('should return error when detail fetch fails', () async {
      // arrange
      when(mockGetDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Detail Error')));
      when(mockGetRecs.execute(tId))
          .thenAnswer((_) async => Right(testShowList));
      // act
      await notifier.fetchDetail(tId);
      // assert
      expect(notifier.itemStatus, RequestState.Error);
      expect(notifier.msg, 'Detail Error');
    });
  });

  group('Watchlist', () {
    test('should get watchlist status', () async {
      // arrange
      when(mockGetStatus.execute(tId)).thenAnswer((_) async => true);
      // act
      await notifier.refreshWatchlistStatus(tId);
      // assert
      expect(notifier.inWatchlist, true);
    });

    test('should add show to watchlist', () async {
      // arrange
      when(mockSave.execute(testShowDetail))
          .thenAnswer((_) async => const Right('Added'));
      when(mockGetStatus.execute(tId)).thenAnswer((_) async => true);
      // act
      await notifier.addToWatchlist(testShowDetail);
      // assert
      verify(mockSave.execute(testShowDetail));
      expect(notifier.watchMsg, 'Added');
    });

    test('should remove show from watchlist', () async {
      // arrange
      when(mockRemove.execute(testShowDetail))
          .thenAnswer((_) async => const Right('Removed'));
      when(mockGetStatus.execute(tId)).thenAnswer((_) async => false);
      // act
      await notifier.removeFromWatchlist(testShowDetail);
      // assert
      verify(mockRemove.execute(testShowDetail));
      expect(notifier.watchMsg, 'Removed');
    });
  });
}
