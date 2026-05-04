import 'package:core/data/models/movie_table.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  test('should return a JSON map containing proper data', () async {
    // act
    final result = tMovieTable.toJson();
    // assert
    final expectedJsonMap = {
      'id': 1,
      'title': 'title',
      'posterPath': 'posterPath',
      'overview': 'overview',
    };
    expect(result, expectedJsonMap);
  });

  test('should map from entity correctly', () {
    final result = MovieTable.fromEntity(testMovieDetail);
    expect(result, isA<MovieTable>());
  });

  test('should map to entity correctly', () {
    final result = tMovieTable.toEntity();
    expect(result, isA<Movie>());
  });
}
