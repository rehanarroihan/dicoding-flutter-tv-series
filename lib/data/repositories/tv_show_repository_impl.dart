import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/datasources/tv_show_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_show_remote_data_source.dart';
import 'package:ditonton/data/models/tv_show_detail_model.dart';
import 'package:ditonton/data/models/tv_show_model.dart';
import 'package:ditonton/data/models/tv_show_table.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:ditonton/domain/repositories/tv_show_repository.dart';

class TvShowRepositoryImpl implements TvShowRepository {
  final TvShowRemoteDataSource remote;
  final TvShowLocalDataSource local;

  TvShowRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<Either<Failure, List<TvShow>>> fetchPopularShows() async {
    try {
      final res = await remote.getPopularShows();
      return Right(res.map((m) => m.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Server Error'));
    } on SocketException {
      return Left(ConnectionFailure('Network Error'));
    }
  }

  @override
  Future<Either<Failure, TvShowDetail>> fetchShowDetail(int id) async {
    try {
      final res = await remote.getShowDetail(id);
      return Right(res.toEntity());
    } on ServerException {
      return Left(ServerFailure('Server Error'));
    } on SocketException {
      return Left(ConnectionFailure('Network Error'));
    }
  }

  @override
  Future<Either<Failure, List<TvShow>>> fetchShowRecommendations(int id) async {
    try {
      final res = await remote.getShowRecommendations(id);
      return Right(res.map((m) => m.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Server Error'));
    } on SocketException {
      return Left(ConnectionFailure('Network Error'));
    }
  }

  @override
  Future<Either<Failure, List<TvShow>>> fetchTopRatedShows() async {
    try {
      final res = await remote.getTopRatedShows();
      return Right(res.map((m) => m.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Server Error'));
    } on SocketException {
      return Left(ConnectionFailure('Network Error'));
    }
  }

  @override
  Future<Either<Failure, List<TvShow>>> fetchOnTheAirShows() async {
    try {
      final res = await remote.getOnTheAirShows();
      return Right(res.map((m) => m.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Server Error'));
    } on SocketException {
      return Left(ConnectionFailure('Network Error'));
    }
  }

  @override
  Future<Either<Failure, List<TvShow>>> findShows(String query) async {
    try {
      final res = await remote.searchShows(query);
      return Right(res.map((m) => m.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Server Error'));
    } on SocketException {
      return Left(ConnectionFailure('Network Error'));
    }
  }

  @override
  Future<Either<Failure, String>> addWatchlist(TvShowDetail show) async {
    try {
      final res = await local.saveWatchlist(TvShowTable.fromEntity(show));
      return Right(res);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvShowDetail show) async {
    try {
      final res = await local.deleteWatchlist(TvShowTable.fromEntity(show));
      return Right(res);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final res = await local.getShowById(id);
    return res != null;
  }

  @override
  Future<Either<Failure, List<TvShow>>> fetchWatchlistShows() async {
    final res = await local.getWatchlistShows();
    return Right(res.map((m) => m.toEntity()).toList());
  }
}
