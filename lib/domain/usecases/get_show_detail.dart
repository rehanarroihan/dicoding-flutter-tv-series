import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:ditonton/domain/repositories/tv_show_repository.dart';

class GetShowDetail {
  final TvShowRepository repo;

  GetShowDetail(this.repo);

  Future<Either<Failure, TvShowDetail>> execute(int id) {
    return repo.fetchShowDetail(id);
  }
}
