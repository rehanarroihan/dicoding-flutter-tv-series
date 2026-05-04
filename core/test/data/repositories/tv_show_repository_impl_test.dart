import 'dart:io';

import 'package:core/common/exception.dart';
import 'package:core/common/failure.dart';
import 'package:core/data/models/tv_show_model.dart';
import 'package:core/data/repositories/tv_show_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../dummy_data/dummy_show_models.dart';
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

  group('Fetch Top Rated Shows', () {
    test('should return list of shows when remote call is success', () async {
      // arrange
      when(mockRemote.getTopRatedShows()).thenAnswer((_) async => tModelList);
      // act
      final result = await repository.fetchTopRatedShows();
      // assert
      verify(mockRemote.getTopRatedShows());
      final resList = result.getOrElse(() => []);
      expect(resList, tShowList);
    });

    test('should return server failure when remote call fails', () async {
      // arrange
      when(mockRemote.getTopRatedShows()).thenThrow(ServerException());
      // act
      final result = await repository.fetchTopRatedShows();
      // assert
      expect(result, Left(ServerFailure('Server Error')));
    });

    test('should return connection failure when no internet', () async {
      // arrange
      when(mockRemote.getTopRatedShows())
          .thenThrow(const SocketException('No Internet'));
      // act
      final result = await repository.fetchTopRatedShows();
      // assert
      expect(result, Left(ConnectionFailure('Network Error')));
    });
  });

  group('Fetch On The Air Shows', () {
    test('should return list of shows when remote call is success', () async {
      // arrange
      when(mockRemote.getOnTheAirShows()).thenAnswer((_) async => tModelList);
      // act
      final result = await repository.fetchOnTheAirShows();
      // assert
      verify(mockRemote.getOnTheAirShows());
      final resList = result.getOrElse(() => []);
      expect(resList, tShowList);
    });

    test('should return server failure when remote call fails', () async {
      // arrange
      when(mockRemote.getOnTheAirShows()).thenThrow(ServerException());
      // act
      final result = await repository.fetchOnTheAirShows();
      // assert
      expect(result, Left(ServerFailure('Server Error')));
    });

    test('should return connection failure when no internet', () async {
      // arrange
      when(mockRemote.getOnTheAirShows())
          .thenThrow(const SocketException('No Internet'));
      // act
      final result = await repository.fetchOnTheAirShows();
      // assert
      expect(result, Left(ConnectionFailure('Network Error')));
    });
  });

  group('Fetch Show Detail', () {
    const tId = 1;
    test('should return show detail when remote call is success', () async {
      // arrange
      when(mockRemote.getShowDetail(tId))
          .thenAnswer((_) async => testShowDetailModel);
      // act
      final result = await repository.fetchShowDetail(tId);
      // assert
      verify(mockRemote.getShowDetail(tId));
      expect(result, Right(testShowDetail));
    });

    test('should return server failure when remote call fails', () async {
      // arrange
      when(mockRemote.getShowDetail(tId)).thenThrow(ServerException());
      // act
      final result = await repository.fetchShowDetail(tId);
      // assert
      expect(result, Left(ServerFailure('Server Error')));
    });

    test('should return connection failure when no internet', () async {
      // arrange
      when(mockRemote.getShowDetail(tId))
          .thenThrow(const SocketException('No Internet'));
      // act
      final result = await repository.fetchShowDetail(tId);
      // assert
      expect(result, Left(ConnectionFailure('Network Error')));
    });
  });

  group('Fetch Show Recommendations', () {
    const tId = 1;
    test('should return list of shows when remote call is success', () async {
      // arrange
      when(mockRemote.getShowRecommendations(tId))
          .thenAnswer((_) async => tModelList);
      // act
      final result = await repository.fetchShowRecommendations(tId);
      // assert
      verify(mockRemote.getShowRecommendations(tId));
      final resList = result.getOrElse(() => []);
      expect(resList, tShowList);
    });

    test('should return server failure when remote call fails', () async {
      // arrange
      when(mockRemote.getShowRecommendations(tId)).thenThrow(ServerException());
      // act
      final result = await repository.fetchShowRecommendations(tId);
      // assert
      expect(result, Left(ServerFailure('Server Error')));
    });

    test('should return connection failure when no internet', () async {
      // arrange
      when(mockRemote.getShowRecommendations(tId))
          .thenThrow(const SocketException('No Internet'));
      // act
      final result = await repository.fetchShowRecommendations(tId);
      // assert
      expect(result, Left(ConnectionFailure('Network Error')));
    });
  });

  group('Search Shows', () {
    const tQuery = 'GOT';
    test('should return list of shows when remote call is success', () async {
      // arrange
      when(mockRemote.searchShows(tQuery)).thenAnswer((_) async => tModelList);
      // act
      final result = await repository.findShows(tQuery);
      // assert
      verify(mockRemote.searchShows(tQuery));
      final resList = result.getOrElse(() => []);
      expect(resList, tShowList);
    });

    test('should return server failure when remote call fails', () async {
      // arrange
      when(mockRemote.searchShows(tQuery)).thenThrow(ServerException());
      // act
      final result = await repository.findShows(tQuery);
      // assert
      expect(result, Left(ServerFailure('Server Error')));
    });

    test('should return connection failure when no internet', () async {
      // arrange
      when(mockRemote.searchShows(tQuery))
          .thenThrow(const SocketException('No Internet'));
      // act
      final result = await repository.findShows(tQuery);
      // assert
      expect(result, Left(ConnectionFailure('Network Error')));
    });
  });

  group('Watchlist Operations', () {
    test('should return success message when saving to watchlist', () async {
      // arrange
      when(mockLocal.saveWatchlist(any))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.addWatchlist(testShowDetail);
      // assert
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return success message when removing from watchlist',
        () async {
      // arrange
      when(mockLocal.deleteWatchlist(any))
          .thenAnswer((_) async => 'Removed from Watchlist');
      // act
      final result = await repository.removeWatchlist(testShowDetail);
      // assert
      expect(result, const Right('Removed from Watchlist'));
    });

    test('should return watchlist status', () async {
      // arrange
      const tId = 1;
      when(mockLocal.getShowById(tId)).thenAnswer((_) async => testShowTable);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, true);
    });

    test('should return watchlist shows', () async {
      // arrange
      when(mockLocal.getWatchlistShows())
          .thenAnswer((_) async => [testShowTable]);
      // act
      final result = await repository.fetchWatchlistShows();
      // assert
      final resList = result.getOrElse(() => []);
      expect(resList, [testWatchlistShow]);
    });

    test('should return database failure when saving fails', () async {
      // arrange
      when(mockLocal.saveWatchlist(any)).thenThrow(DatabaseException('Failed'));
      // act
      final result = await repository.addWatchlist(testShowDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed')));
    });
  });
}
