import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_show_detail.dart';
import 'package:core/domain/repositories/tv_show_repository.dart';
import 'package:dartz/dartz.dart';

class SaveToWatchlist {
  final TvShowRepository repo;

  SaveToWatchlist(this.repo);

  Future<Either<Failure, String>> execute(TvShowDetail show) {
    return repo.addWatchlist(show);
  }
}
