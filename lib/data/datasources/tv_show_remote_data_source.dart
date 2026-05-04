import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_show_detail_model.dart';
import 'package:ditonton/data/models/tv_show_model.dart';
import 'package:ditonton/data/models/tv_show_response.dart';
import 'package:http/http.dart' as http;

abstract class TvShowRemoteDataSource {
  Future<List<TvShowModel>> getPopularShows();

  Future<TvShowDetailModel> getShowDetail(int id);

  Future<List<TvShowModel>> getShowRecommendations(int id);

  Future<List<TvShowModel>> getTopRatedShows();

  Future<List<TvShowModel>> getOnTheAirShows();

  Future<List<TvShowModel>> searchShows(String query);
}

class TvShowRemoteDataSourceImpl implements TvShowRemoteDataSource {
  static const API_KEY = '2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  TvShowRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvShowModel>> getPopularShows() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/popular?api_key=$API_KEY'));
    if (response.statusCode == 200) {
      return TvShowResponse.fromMap(json.decode(response.body)).items;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvShowDetailModel> getShowDetail(int id) async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/$id?api_key=$API_KEY'));
    if (response.statusCode == 200) {
      return TvShowDetailModel.fromMap(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> getShowRecommendations(int id) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/tv/$id/recommendations?api_key=$API_KEY'));
    if (response.statusCode == 200) {
      return TvShowResponse.fromMap(json.decode(response.body)).items;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> getTopRatedShows() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/top_rated?api_key=$API_KEY'));
    if (response.statusCode == 200) {
      return TvShowResponse.fromMap(json.decode(response.body)).items;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> getOnTheAirShows() async {
    final response = await client
        .get(Uri.parse('$BASE_URL/tv/airing_today?api_key=$API_KEY'));
    if (response.statusCode == 200) {
      return TvShowResponse.fromMap(json.decode(response.body)).items;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> searchShows(String query) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/search/tv?api_key=$API_KEY&query=$query'));
    if (response.statusCode == 200) {
      return TvShowResponse.fromMap(json.decode(response.body)).items;
    } else {
      throw ServerException();
    }
  }
}
