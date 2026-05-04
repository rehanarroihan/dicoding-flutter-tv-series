import 'package:core/data/models/movie_table.dart';
import 'package:core/data/models/tv_show_table.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/entities/tv_show_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

// TV SHOWS
final testShowDetail = TvShowDetail(
  genres: [Genre(id: 1, name: 'Drama')],
  id: 1399,
  name: 'Game of Thrones',
  episodeCount: 73,
  seasonCount: 8,
  overview:
      'Seven noble families fight for control of the mythical land of Westeros.',
  posterPath: '/gwPSoYmZRHFO6Bs9AdqS0Y7Y0rs.jpg',
  rating: 8.3,
);

final testShow = TvShow(
  name: 'Game of Thrones',
  airDate: '2011-04-17',
  backdropPath: '/suPo9j1B7exIuUfHgsn9sbrvP9i.jpg',
  genreIds: [10765, 18, 10759],
  id: 1399,
  overview:
      'Seven noble families fight for control of the mythical land of Westeros.',
  popularity: 369.594,
  posterPath: '/gwPSoYmZRHFO6Bs9AdqS0Y7Y0rs.jpg',
  countries: ['US'],
  originalLanguage: 'en',
  originalName: 'Game of Thrones',
  rating: 8.3,
  ratingCount: 11500,
);

final testShowList = [testShow];

final testShowTable = TvShowTable(
  id: 1399,
  name: 'Game of Thrones',
  posterPath: '/gwPSoYmZRHFO6Bs9AdqS0Y7Y0rs.jpg',
  overview:
      'Seven noble families fight for control of the mythical land of Westeros.',
);

final testShowMap = {
  'id': 1399,
  'overview':
      'Seven noble families fight for control of the mythical land of Westeros.',
  'posterPath': '/gwPSoYmZRHFO6Bs9AdqS0Y7Y0rs.jpg',
  'title': 'Game of Thrones',
};

final testWatchlistShow = TvShow.watchlist(
  id: 1399,
  name: 'Game of Thrones',
  posterPath: '/gwPSoYmZRHFO6Bs9AdqS0Y7Y0rs.jpg',
  overview:
      'Seven noble families fight for control of the mythical land of Westeros.',
);
