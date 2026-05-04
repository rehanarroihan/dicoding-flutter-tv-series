import 'package:core/domain/entities/genre.dart';
import 'package:equatable/equatable.dart';

class TvShowDetail extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final List<Genre> genres;
  final double rating;
  final int seasonCount;
  final int episodeCount;

  TvShowDetail({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.genres,
    required this.rating,
    required this.seasonCount,
    required this.episodeCount,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        posterPath,
        genres,
        rating,
        seasonCount,
        episodeCount,
      ];
}
