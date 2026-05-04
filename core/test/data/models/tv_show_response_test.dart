import 'package:core/data/models/tv_show_model.dart';
import 'package:core/data/models/tv_show_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tModel = TvShowModel(
    id: 123,
    name: 'movie_title',
    overview: 'lorem ipsum 123',
    posterPath: '/poster_path.jpg',
    backdropPath: '/img_path.jpg',
    firstAirDate: '2000-10-10',
    genreIds: [1, 2],
    originCountry: ['ID'],
    originalLanguage: 'id',
    originalName: 'movie_title',
    popularity: 144.0,
    voteAverage: 9.5,
    voteCount: 123,
  );

  final tResponse = TvShowResponse(items: [tModel]);

  group('TvShowResponse', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = {
        'results': [
          {
            'backdrop_path': '/img_path.jpg',
            'first_air_date': '2000-10-10',
            'genre_ids': [1, 2],
            'id': 123,
            'name': 'movie_title',
            'origin_country': ['ID'],
            'original_language': 'id',
            'original_name': 'movie_title',
            'overview': 'lorem ipsum 123',
            'popularity': 144.0,
            'poster_path': '/poster_path.jpg',
            'vote_average': 9.5,
            'vote_count': 123,
          }
        ],
      };
      // act
      final result = TvShowResponse.fromMap(jsonMap);
      // assert
      expect(result, tResponse);
    });

    test('should return a JSON map containing proper data', () async {
      // act
      final result = tResponse.toMap();
      // assert
      final expectedMap = {
        'results': [
          {
            'id': 123,
            'name': 'movie_title',
            'overview': 'lorem ipsum 123',
            'poster_path': '/poster_path.jpg',
            'backdrop_path': '/img_path.jpg',
            'first_air_date': '2000-10-10',
            'genre_ids': [1, 2],
            'origin_country': ['ID'],
            'original_language': 'id',
            'original_name': 'movie_title',
            'popularity': 144.0,
            'vote_average': 9.5,
            'vote_count': 123,
          }
        ],
      };
      expect(result, expectedMap);
    });
  });
}
