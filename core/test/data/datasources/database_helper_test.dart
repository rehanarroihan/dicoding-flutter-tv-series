import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/models/movie_table.dart';
import 'package:core/data/models/tv_show_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    await DatabaseHelper.resetInstanceForTest();
    final dbPath = await getDatabasesPath();
    await deleteDatabase('$dbPath/ditonton2.db');
  });

  test('database getter caches initialized database instance', () async {
    final helper = DatabaseHelper();

    final db1 = await helper.database;
    final db2 = await helper.database;

    expect(db1, isNotNull);
    expect(identical(db1, db2), isTrue);
  });

  test('movie watchlist CRUD works', () async {
    final helper = DatabaseHelper();
    final movie = MovieTable(
      id: 1,
      title: 'title',
      overview: 'overview',
      posterPath: '/poster.jpg',
    );

    expect(await helper.getMovieById(1), isNull);

    final insertId = await helper.insertWatchlist(movie);
    expect(insertId, greaterThanOrEqualTo(1));

    final movieRow = await helper.getMovieById(1);
    expect(movieRow, isNotNull);
    expect(movieRow!['id'], 1);
    expect(movieRow['title'], 'title');

    final allMovies = await helper.getWatchlistMovies();
    expect(allMovies, isNotEmpty);

    final deletedCount = await helper.removeWatchlist(movie);
    expect(deletedCount, 1);
    expect(await helper.getMovieById(1), isNull);
  });

  test('show watchlist CRUD works', () async {
    final helper = DatabaseHelper();
    final show = TvShowTable(
      id: 101,
      name: 'name',
      overview: 'overview',
      posterPath: '/poster.jpg',
    );

    expect(await helper.fetchShowById(101), isNull);

    final insertId = await helper.persistShow(show);
    expect(insertId, greaterThanOrEqualTo(1));

    final showRow = await helper.fetchShowById(101);
    expect(showRow, isNotNull);
    expect(showRow!['id'], 101);
    expect(showRow['title'], 'name');

    final allShows = await helper.fetchWatchlistShows();
    expect(allShows, isNotEmpty);

    final deletedCount = await helper.deleteShow(show);
    expect(deletedCount, 1);
    expect(await helper.fetchShowById(101), isNull);
  });
}
