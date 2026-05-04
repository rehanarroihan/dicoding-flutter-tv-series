import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/repositories/tv_show_repository.dart';
import 'package:dartz/dartz.dart';

class GetTopRatedShows {
  final TvShowRepository repo;

  GetTopRatedShows(this.repo);

  Future<Either<Failure, List<TvShow>>> execute() {
    return repo.fetchTopRatedShows();
  }
}
