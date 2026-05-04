import 'dart:convert';

import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/tv_show_detail_model.dart';
import 'package:core/domain/entities/tv_show_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvShowDetailModel = TvShowDetailModel(
    id: 123,
    name: 'movie_title',
    overview: 'lorem ipsum 123',
    posterPath: '/poster_path.jpg',
    genres: [GenreModel(id: 1, name: 'Action')],
    voteAverage: 9.5,
    numberOfSeasons: 1,
    numberOfEpisodes: 1,
  );

  group('fromMap', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('tv_detail.json'));
      // act
      final result = TvShowDetailModel.fromMap(jsonMap);
      // assert
      expect(result, tTvShowDetailModel);
    });
  });

  group('toEntity', () {
    test('should be a subclass of TvShowDetail entity', () async {
      // act
      final result = tTvShowDetailModel.toEntity();
      // assert
      expect(result, isA<TvShowDetail>());
    });
  });
}
