import 'package:equatable/equatable.dart';

class TvShow extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final String? backdropPath;
  final String? airDate;
  final List<int>? genreIds;
  final List<String>? countries;
  final String? originalLanguage;
  final String? originalName;
  final double? popularity;
  final double? rating;
  final int? ratingCount;

  TvShow({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    this.backdropPath,
    this.airDate,
    this.genreIds,
    this.countries,
    this.originalLanguage,
    this.originalName,
    this.popularity,
    this.rating,
    this.ratingCount,
  });

  TvShow.watchlist({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
  })  : backdropPath = null,
        airDate = null,
        genreIds = null,
        countries = null,
        originalLanguage = null,
        originalName = null,
        popularity = null,
        rating = null,
        ratingCount = null;

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        posterPath,
        backdropPath,
        airDate,
        genreIds,
        countries,
        originalLanguage,
        originalName,
        popularity,
        rating,
        ratingCount,
      ];
}
