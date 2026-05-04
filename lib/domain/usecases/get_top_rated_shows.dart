import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/repositories/tv_show_repository.dart';

class GetTopRatedShows {
  final TvShowRepository repo;

  GetTopRatedShows(this.repo);

  Future<Either<Failure, List<TvShow>>> execute() {
    return repo.fetchTopRatedShows();
  }
}
