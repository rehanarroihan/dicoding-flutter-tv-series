import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/repositories/tv_show_repository.dart';
import 'package:dartz/dartz.dart';

class GetPopularShows {
  final TvShowRepository repo;

  GetPopularShows(this.repo);

  Future<Either<Failure, List<TvShow>>> execute() {
    return repo.fetchPopularShows();
  }
}
