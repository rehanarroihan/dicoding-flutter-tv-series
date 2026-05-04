import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/tv_show_detail_model.dart';

final testShowDetailModel = TvShowDetailModel(
  id: 1399,
  name: 'Game of Thrones',
  overview:
      'Seven noble families fight for control of the mythical land of Westeros.',
  posterPath: '/gwPSoYmZRHFO6Bs9AdqS0Y7Y0rs.jpg',
  genres: [GenreModel(id: 1, name: 'Drama')],
  voteAverage: 8.3,
  numberOfSeasons: 8,
  numberOfEpisodes: 73,
);
