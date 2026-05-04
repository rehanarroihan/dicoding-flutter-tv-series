import 'package:core/data/models/tv_show_model.dart';
import 'package:core/data/models/tv_show_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tModel = TvShowModel(
    id: 1,
    name: 'name',
    overview: 'overview',
    posterPath: 'path',
  );

  final tResponse = TvShowResponse(items: [tModel]);

  group('TvShowResponse', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = {
        'results': [
          {
            'id': 1,
            'name': 'name',
            'overview': 'overview',
            'poster_path': 'path',
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
            'id': 1,
            'name': 'name',
            'overview': 'overview',
            'poster_path': 'path',
            'backdrop_path': null,
            'first_air_date': null,
            'genre_ids': null,
            'origin_country': null,
            'original_language': null,
            'original_name': null,
            'popularity': null,
            'vote_average': null,
            'vote_count': null,
          }
        ],
      };
      expect(result, expectedMap);
    });
  });
}
