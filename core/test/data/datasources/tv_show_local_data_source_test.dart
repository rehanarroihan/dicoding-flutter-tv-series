import 'package:core/common/exception.dart';
import 'package:core/data/datasources/tv_show_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvShowLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockHelper;

  setUp(() {
    mockHelper = MockDatabaseHelper();
    dataSource = TvShowLocalDataSourceImpl(databaseHelper: mockHelper);
  });

  group('saveWatchlist', () {
    test('should return success message when saving to DB', () async {
      // arrange
      when(mockHelper.persistShow(testShowTable)).thenAnswer((_) async => 1);
      // act
      final result = await dataSource.saveWatchlist(testShowTable);
      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when DB error occurs', () async {
      // arrange
      when(mockHelper.persistShow(testShowTable)).thenThrow(Exception());
      // act
      final call = dataSource.saveWatchlist(testShowTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('deleteWatchlist', () {
    test('should return success message when removing from DB', () async {
      // arrange
      when(mockHelper.deleteShow(testShowTable)).thenAnswer((_) async => 1);
      // act
      final result = await dataSource.deleteWatchlist(testShowTable);
      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when DB error occurs', () async {
      // arrange
      when(mockHelper.deleteShow(testShowTable)).thenThrow(Exception());
      // act
      final call = dataSource.deleteWatchlist(testShowTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('getShowById', () {
    const tId = 1;
    test('should return model when data found', () async {
      // arrange
      when(mockHelper.fetchShowById(tId))
          .thenAnswer((_) async => testShowTable.toMap());
      // act
      final result = await dataSource.getShowById(tId);
      // assert
      expect(result, testShowTable);
    });

    test('should return null when data not found', () async {
      // arrange
      when(mockHelper.fetchShowById(tId)).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getShowById(tId);
      // assert
      expect(result, null);
    });
  });

  group('getWatchlistShows', () {
    test('should return list of models from DB', () async {
      // arrange
      when(mockHelper.fetchWatchlistShows())
          .thenAnswer((_) async => [testShowTable.toMap()]);
      // act
      final result = await dataSource.getWatchlistShows();
      // assert
      expect(result, [testShowTable]);
    });
  });
}
