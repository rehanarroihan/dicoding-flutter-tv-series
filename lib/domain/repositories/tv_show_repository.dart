import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';

abstract class TvShowRepository {
  Future<Either<Failure, List<TvShow>>> fetchPopularShows();

  Future<Either<Failure, TvShowDetail>> fetchShowDetail(int id);

  Future<Either<Failure, List<TvShow>>> fetchShowRecommendations(int id);

  Future<Either<Failure, List<TvShow>>> fetchTopRatedShows();

  Future<Either<Failure, List<TvShow>>> fetchOnTheAirShows();

  Future<Either<Failure, List<TvShow>>> findShows(String query);

  Future<Either<Failure, String>> addWatchlist(TvShowDetail show);

  Future<Either<Failure, String>> removeWatchlist(TvShowDetail show);

  Future<bool> isAddedToWatchlist(int id);

  Future<Either<Failure, List<TvShow>>> fetchWatchlistShows();
}
