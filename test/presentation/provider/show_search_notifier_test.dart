import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/search_shows.dart';
import 'package:ditonton/presentation/provider/show_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'show_search_notifier_test.mocks.dart';

@GenerateMocks([SearchShows])
void main() {
  late MockSearchShows mockSearch;
  late ShowSearchNotifier notifier;
  late int callCount;

  setUp(() {
    callCount = 0;
    mockSearch = MockSearchShows();
    notifier = ShowSearchNotifier(mockSearch)
      ..addListener(() {
        callCount++;
      });
  });

  const tQuery = 'game';

  test('should update state to loading during search', () async {
    // arrange
    when(mockSearch.execute(tQuery))
        .thenAnswer((_) async => Right(testShowList));
    // act
    notifier.executeSearch(tQuery);
    // assert
    expect(notifier.searchStatus, RequestState.Loading);
    expect(callCount, 1);
  });

  test('should provide search results on success', () async {
    // arrange
    when(mockSearch.execute(tQuery))
        .thenAnswer((_) async => Right(testShowList));
    // act
    await notifier.executeSearch(tQuery);
    // assert
    expect(notifier.searchStatus, RequestState.Loaded);
    expect(notifier.results, testShowList);
    expect(callCount, 2);
  });

  test('should return error when search fails', () async {
    // arrange
    when(mockSearch.execute(tQuery))
        .thenAnswer((_) async => Left(ServerFailure('Search Error')));
    // act
    await notifier.executeSearch(tQuery);
    // assert
    expect(notifier.searchStatus, RequestState.Error);
    expect(notifier.info, 'Search Error');
    expect(callCount, 2);
  });
}
