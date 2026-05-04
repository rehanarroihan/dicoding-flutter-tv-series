import 'dart:convert';

import 'package:core/data/models/movie_detail_model.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tMovieDetailResponse = MovieDetailResponse(
    adult: false,
    backdropPath: '/path.jpg',
    budget: 100,
    genres: [],
    homepage: 'https://google.com',
    id: 1,
    imdbId: 'id123',
    originalLanguage: 'en',
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    releaseDate: '2020-05-05',
    revenue: 100,
    runtime: 100,
    status: 'Status',
    tagline: 'Tagline',
    title: 'Title',
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );

  group('fromMap', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('movie_detail.json'));
      // act
      final result = MovieDetailResponse.fromMap(jsonMap);
      // assert
      expect(result.id, 1);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // act
      final result = tMovieDetailResponse.toJson();
      // assert
      expect(result['id'], 1);
    });
  });

  group('toEntity', () {
    test('should be a subclass of MovieDetail entity', () async {
      // act
      final result = tMovieDetailResponse.toEntity();
      // assert
      expect(result, isA<MovieDetail>());
    });
  });
}
