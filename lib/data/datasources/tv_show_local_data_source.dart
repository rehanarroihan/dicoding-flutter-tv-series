import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/tv_show_table.dart';

abstract class TvShowLocalDataSource {
  Future<String> saveWatchlist(TvShowTable show);

  Future<String> deleteWatchlist(TvShowTable show);

  Future<TvShowTable?> getShowById(int id);

  Future<List<TvShowTable>> getWatchlistShows();
}

class TvShowLocalDataSourceImpl implements TvShowLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvShowLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> saveWatchlist(TvShowTable show) async {
    try {
      await databaseHelper.persistShow(show);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> deleteWatchlist(TvShowTable show) async {
    try {
      await databaseHelper.deleteShow(show);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvShowTable?> getShowById(int id) async {
    final result = await databaseHelper.fetchShowById(id);
    if (result != null) {
      return TvShowTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvShowTable>> getWatchlistShows() async {
    final result = await databaseHelper.fetchWatchlistShows();
    return result.map((data) => TvShowTable.fromMap(data)).toList();
  }
}
