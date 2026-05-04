import 'dart:convert';

import 'package:core/common/exception.dart';
import 'package:core/data/datasources/tv_show_remote_data_source.dart';
import 'package:core/data/models/tv_show_detail_model.dart';
import 'package:core/data/models/tv_show_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const apiKey = '2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TvShowRemoteDataSourceImpl dataSource;
  late MockHttpClient mockClient;

  setUp(() {
    mockClient = MockHttpClient();
    dataSource = TvShowRemoteDataSourceImpl(client: mockClient);
  });

  group('Get Popular Shows', () {
    final tTvList =
        TvShowResponse.fromMap(json.decode(readJson('tv_series_popular.json')))
            .items;

    test('should return list of models when status is 200', () async {
      // arrange
      when(mockClient.get(Uri.parse('$baseUrl/tv/popular?api_key=$apiKey')))
          .thenAnswer(
        (_) async => http.Response(readJson('tv_series_popular.json'), 200),
      );
      // act
      final result = await dataSource.getPopularShows();
      // assert
      expect(result, tTvList);
    });

    test('should throw ServerException when status is not 200', () async {
      // arrange
      when(mockClient.get(Uri.parse('$baseUrl/tv/popular?api_key=$apiKey')))
          .thenAnswer((_) async => http.Response('Error', 404));
      // act
      final call = dataSource.getPopularShows();
      // assert
      expect(call, throwsA(isA<ServerException>()));
    });
  });

  group('Get Top Rated Shows', () {
    final tTvList = TvShowResponse.fromMap(
      json.decode(readJson('tv_series_top_rated.json')),
    ).items;

    test('should return list of models when status is 200', () async {
      // arrange
      when(mockClient.get(Uri.parse('$baseUrl/tv/top_rated?api_key=$apiKey')))
          .thenAnswer(
        (_) async => http.Response(readJson('tv_series_top_rated.json'), 200),
      );
      // act
      final result = await dataSource.getTopRatedShows();
      // assert
      expect(result, tTvList);
    });

    test('should throw ServerException when status is not 200', () async {
      // arrange
      when(mockClient.get(Uri.parse('$baseUrl/tv/top_rated?api_key=$apiKey')))
          .thenAnswer((_) async => http.Response('Error', 404));
      // act
      final call = dataSource.getTopRatedShows();
      // assert
      expect(call, throwsA(isA<ServerException>()));
    });
  });

  group('Get On The Air Shows', () {
    final tTvList = TvShowResponse.fromMap(
      json.decode(readJson('tv_series_now_showing_today.json')),
    ).items;

    test('should return list of models when status is 200', () async {
      // arrange
      when(
        mockClient.get(Uri.parse('$baseUrl/tv/airing_today?api_key=$apiKey')),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('tv_series_now_showing_today.json'), 200),
      );
      // act
      final result = await dataSource.getOnTheAirShows();
      // assert
      expect(result, tTvList);
    });

    test('should throw ServerException when status is not 200', () async {
      // arrange
      when(
        mockClient.get(Uri.parse('$baseUrl/tv/airing_today?api_key=$apiKey')),
      ).thenAnswer((_) async => http.Response('Error', 404));
      // act
      final call = dataSource.getOnTheAirShows();
      // assert
      expect(call, throwsA(isA<ServerException>()));
    });
  });

  group('Get Show Detail', () {
    const tId = 1;
    final tTvDetail =
        TvShowDetailModel.fromMap(json.decode(readJson('tv_detail.json')));

    test('should return model when status is 200', () async {
      // arrange
      when(mockClient.get(Uri.parse('$baseUrl/tv/$tId?api_key=$apiKey')))
          .thenAnswer(
        (_) async => http.Response(readJson('tv_detail.json'), 200),
      );
      // act
      final result = await dataSource.getShowDetail(tId);
      // assert
      expect(result, tTvDetail);
    });

    test('should throw ServerException when status is not 200', () async {
      // arrange
      when(mockClient.get(Uri.parse('$baseUrl/tv/$tId?api_key=$apiKey')))
          .thenAnswer((_) async => http.Response('Error', 404));
      // act
      final call = dataSource.getShowDetail(tId);
      // assert
      expect(call, throwsA(isA<ServerException>()));
    });
  });

  group('Get Show Recommendations', () {
    const tId = 1;
    final tTvList =
        TvShowResponse.fromMap(json.decode(readJson('tv_series_popular.json')))
            .items;

    test('should return list of models when status is 200', () async {
      // arrange
      when(
        mockClient.get(
          Uri.parse('$baseUrl/tv/$tId/recommendations?api_key=$apiKey'),
        ),
      ).thenAnswer(
        (_) async => http.Response(readJson('tv_series_popular.json'), 200),
      );
      // act
      final result = await dataSource.getShowRecommendations(tId);
      // assert
      expect(result, tTvList);
    });

    test('should throw ServerException when status is not 200', () async {
      // arrange
      when(
        mockClient.get(
          Uri.parse('$baseUrl/tv/$tId/recommendations?api_key=$apiKey'),
        ),
      ).thenAnswer((_) async => http.Response('Error', 404));
      // act
      final call = dataSource.getShowRecommendations(tId);
      // assert
      expect(call, throwsA(isA<ServerException>()));
    });
  });

  group('Search Shows', () {
    const tQuery = 'Game of Thrones';
    final tTvList =
        TvShowResponse.fromMap(json.decode(readJson('tv_series_popular.json')))
            .items;

    test('should return list of models when status is 200', () async {
      // arrange
      when(
        mockClient.get(
          Uri.parse('$baseUrl/search/tv?api_key=$apiKey&query=$tQuery'),
        ),
      ).thenAnswer(
        (_) async => http.Response(readJson('tv_series_popular.json'), 200),
      );
      // act
      final result = await dataSource.searchShows(tQuery);
      // assert
      expect(result, tTvList);
    });

    test('should throw ServerException when status is not 200', () async {
      // arrange
      when(
        mockClient.get(
          Uri.parse('$baseUrl/search/tv?api_key=$apiKey&query=$tQuery'),
        ),
      ).thenAnswer((_) async => http.Response('Error', 404));
      // act
      final call = dataSource.searchShows(tQuery);
      // assert
      expect(call, throwsA(isA<ServerException>()));
    });
  });
}
