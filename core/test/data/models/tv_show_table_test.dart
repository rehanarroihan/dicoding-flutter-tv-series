import 'package:core/data/models/tv_show_table.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final tTvShowTable = TvShowTable(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  test('should return a JSON map containing proper data', () async {
    // act
    final result = tTvShowTable.toMap();
    // assert
    final expectedJsonMap = {
      'id': 1,
      'title': 'name',
      'posterPath': 'posterPath',
      'overview': 'overview',
    };
    expect(result, expectedJsonMap);
  });

  test('should map from entity correctly', () {
    final result = TvShowTable.fromEntity(testShowDetail);
    expect(result, isA<TvShowTable>());
  });

  test('should map to entity correctly', () {
    final result = tTvShowTable.toEntity();
    expect(result, isA<TvShow>());
  });
}
