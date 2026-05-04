import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_show_detail.dart';
import 'package:core/domain/repositories/tv_show_repository.dart';
import 'package:dartz/dartz.dart';

class GetShowDetail {
  final TvShowRepository repo;

  GetShowDetail(this.repo);

  Future<Either<Failure, TvShowDetail>> execute(int id) {
    return repo.fetchShowDetail(id);
  }
}
