import 'package:core/domain/repositories/tv_show_repository.dart';

class GetShowWatchlistStatus {
  final TvShowRepository repo;

  GetShowWatchlistStatus(this.repo);

  Future<bool> execute(int id) {
    return repo.isAddedToWatchlist(id);
  }
}
