import 'dart:convert';

import 'package:core/common/exception.dart';
import 'package:core/data/datasources/tv_show_remote_data_source.dart';
import 'package:core/data/models/tv_show_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  const apiKey = '2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TvShowRemoteDataSourceImpl dataSource;
  late MockHttpClient mockClient;

  setUp(() {
    mockClient = MockHttpClient();
    dataSource = TvShowRemoteDataSourceImpl(client: mockClient);
  });

  const tJson = '''
  {
    "results": [
      {
        "id": 1399,
        "name": "Game of Thrones",
        "overview": "overview",
        "poster_path": "/path.jpg"
      }
    ]
  }
  ''';

  group('Get Popular Shows', () {
    test('should return list of models when status is 200', () async {
      // arrange
      when(mockClient.get(Uri.parse('$baseUrl/tv/popular?api_key=$apiKey')))
          .thenAnswer((_) async => http.Response(tJson, 200));
      // act
      final result = await dataSource.getPopularShows();
      // assert
      expect(result, TvShowResponse.fromMap(json.decode(tJson)).items);
    });

    test('should throw ServerException when status is not 200', () async {
      // arrange
      when(mockClient.get(Uri.parse('$baseUrl/tv/popular?api_key=$apiKey')))
          .thenAnswer((_) async => http.Response('Error', 404));
      // act
      final call = dataSource.getPopularShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
