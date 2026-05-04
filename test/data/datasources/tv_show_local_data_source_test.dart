import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_show_local_data_source.dart';
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

  group('Watchlist Local Source', () {
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
}
