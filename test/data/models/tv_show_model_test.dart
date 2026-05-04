import 'package:ditonton/data/models/tv_show_model.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
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
}
