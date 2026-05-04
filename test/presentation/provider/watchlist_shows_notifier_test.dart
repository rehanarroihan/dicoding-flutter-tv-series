import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_shows.dart';
import 'package:ditonton/presentation/provider/watchlist_shows_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_shows_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistShows])
void main() {
  late MockGetWatchlistShows mockGetWatchlist;
  late WatchlistShowsNotifier notifier;
  late int callCount;

  setUp(() {
    callCount = 0;
    mockGetWatchlist = MockGetWatchlistShows();
    notifier = WatchlistShowsNotifier(mockGetWatchlist)
      ..addListener(() {
        callCount++;
      });
  });

  test('should set loading state when fetching watchlist', () async {
    // arrange
    when(mockGetWatchlist.execute())
        .thenAnswer((_) async => Right(testShowList));
    // act
    notifier.loadWatchlist();
    // assert
    expect(notifier.watchlistState, RequestState.Loading);
    expect(callCount, 1);
  });

  test('should update watchlist data when successful', () async {
    // arrange
    when(mockGetWatchlist.execute())
        .thenAnswer((_) async => Right(testShowList));
    // act
    await notifier.loadWatchlist();
    // assert
    expect(notifier.watchlistState, RequestState.Loaded);
    expect(notifier.watchlistItems, testShowList);
    expect(callCount, 2);
  });

  test('should show error when watchlist retrieval fails', () async {
    // arrange
    when(mockGetWatchlist.execute())
        .thenAnswer((_) async => Left(DatabaseFailure('DB Error')));
    // act
    await notifier.loadWatchlist();
    // assert
    expect(notifier.watchlistState, RequestState.Error);
    expect(notifier.err, 'DB Error');
    expect(callCount, 2);
  });
}
