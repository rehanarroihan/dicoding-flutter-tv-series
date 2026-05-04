import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tv_show_model.dart';
import 'package:ditonton/data/models/tv_show_table.dart';
import 'package:ditonton/data/repositories/tv_show_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvShowRepositoryImpl repository;
  late MockTvShowRemoteDataSource mockRemote;
  late MockTvShowLocalDataSource mockLocal;

  setUp(() {
    mockRemote = MockTvShowRemoteDataSource();
    mockLocal = MockTvShowLocalDataSource();
    repository = TvShowRepositoryImpl(remote: mockRemote, local: mockLocal);
  });

  final tModel = TvShowModel(
    id: 1399,
    name: 'Game of Thrones',
    overview: 'overview',
    posterPath: '/path.jpg',
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2011-04-17',
    genreIds: [1, 2],
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'GOT',
    popularity: 100.0,
    voteAverage: 8.3,
    voteCount: 1000,
  );

  final tShow = tModel.toEntity();
  final tModelList = [tModel];
  final tShowList = [tShow];

  group('Fetch Popular Shows', () {
    test('should return list of shows when remote call is success', () async {
      // arrange
      when(mockRemote.getPopularShows()).thenAnswer((_) async => tModelList);
      // act
      final result = await repository.fetchPopularShows();
      // assert
      verify(mockRemote.getPopularShows());
      final resList = result.getOrElse(() => []);
      expect(resList, tShowList);
    });

    test('should return server failure when remote call fails', () async {
      // arrange
      when(mockRemote.getPopularShows()).thenThrow(ServerException());
      // act
      final result = await repository.fetchPopularShows();
      // assert
      expect(result, Left(ServerFailure('Server Error')));
    });

    test('should return connection failure when no internet', () async {
      // arrange
      when(mockRemote.getPopularShows())
          .thenThrow(const SocketException('No Internet'));
      // act
      final result = await repository.fetchPopularShows();
      // assert
      expect(result, Left(ConnectionFailure('Network Error')));
    });
  });

  group('Watchlist Operations', () {
    test('should return success message when saving to watchlist', () async {
      // arrange
      when(mockLocal.saveWatchlist(TvShowTable.fromEntity(testShowDetail)))
          .thenAnswer((_) async => 'Added');
      // act
      final result = await repository.addWatchlist(testShowDetail);
      // assert
      expect(result, Right('Added'));
    });

    test('should return database failure when saving fails', () async {
      // arrange
      when(mockLocal.saveWatchlist(TvShowTable.fromEntity(testShowDetail)))
          .thenThrow(DatabaseException('Failed'));
      // act
      final result = await repository.addWatchlist(testShowDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed')));
    });
  });
}
