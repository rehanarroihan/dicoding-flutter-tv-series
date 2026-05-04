import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:ditonton/domain/repositories/tv_show_repository.dart';

class SaveToWatchlist {
  final TvShowRepository repo;

  SaveToWatchlist(this.repo);

  Future<Either<Failure, String>> execute(TvShowDetail show) {
    return repo.addWatchlist(show);
  }
}
