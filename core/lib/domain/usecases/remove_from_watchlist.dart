import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_show_detail.dart';
import 'package:core/domain/repositories/tv_show_repository.dart';

class RemoveFromWatchlist {
  final TvShowRepository repo;

  RemoveFromWatchlist(this.repo);

  Future<Either<Failure, String>> execute(TvShowDetail show) {
    return repo.removeWatchlist(show);
  }
}
