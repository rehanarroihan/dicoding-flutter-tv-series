import 'package:core/data/models/tv_show_model.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tModel = TvShowModel(
    id: 1,
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
    backdropPath: 'backdropPath',
    firstAirDate: '2020-01-01',
    genreIds: [1, 2],
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'originalName',
    popularity: 1.0,
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tEntity = TvShow(
    id: 1,
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
    backdropPath: 'backdropPath',
    airDate: '2020-01-01',
    genreIds: [1, 2],
    countries: ['US'],
    originalLanguage: 'en',
    originalName: 'originalName',
    popularity: 1.0,
    rating: 1.0,
    ratingCount: 1,
  );

  test('should map to entity correctly', () async {
    final result = tModel.toEntity();
    expect(result, tEntity);
  });

  test('should create from map correctly', () {
    final map = {
      'id': 1,
      'name': 'name',
      'overview': 'overview',
      'poster_path': 'posterPath',
      'backdrop_path': 'backdropPath',
      'first_air_date': '2020-01-01',
      'genre_ids': [1, 2],
      'origin_country': ['US'],
      'original_language': 'en',
      'original_name': 'originalName',
      'popularity': 1.0,
      'vote_average': 1.0,
      'vote_count': 1,
    };
    final result = TvShowModel.fromMap(map);
    expect(result, tModel);
  });

  test('should return json map correctly', () {
    final result = tModel.toMap();
    final expectedMap = {
      'id': 1,
      'name': 'name',
      'overview': 'overview',
      'poster_path': 'posterPath',
      'backdrop_path': 'backdropPath',
      'first_air_date': '2020-01-01',
      'genre_ids': [1, 2],
      'origin_country': ['US'],
      'original_language': 'en',
      'original_name': 'originalName',
      'popularity': 1.0,
      'vote_average': 1.0,
      'vote_count': 1,
    };
    expect(result, expectedMap);
  });
}
