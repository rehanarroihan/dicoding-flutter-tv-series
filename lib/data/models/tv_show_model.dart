import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:equatable/equatable.dart';

class TvShowModel extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String? firstAirDate;
  final List<int>? genreIds;
  final List<String>? originCountry;
  final String? originalLanguage;
  final String? originalName;
  final double? popularity;
  final double? voteAverage;
  final int? voteCount;

  TvShowModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    this.backdropPath,
    this.firstAirDate,
    this.genreIds,
    this.originCountry,
    this.originalLanguage,
    this.originalName,
    this.popularity,
    this.voteAverage,
    this.voteCount,
  });

  factory TvShowModel.fromMap(Map<String, dynamic> json) => TvShowModel(
        id: json['id'],
        name: json['name'],
        overview: json['overview'],
        posterPath: json['poster_path'],
        backdropPath: json['backdrop_path'],
        firstAirDate: json['first_air_date'],
        genreIds: json['genre_ids'] != null
            ? List<int>.from(json['genre_ids'].map((x) => x))
            : null,
        originCountry: json['origin_country'] != null
            ? List<String>.from(json['origin_country'].map((x) => x))
            : null,
        originalLanguage: json['original_language'],
        originalName: json['original_name'],
        popularity: json['popularity']?.toDouble(),
        voteAverage: json['vote_average']?.toDouble(),
        voteCount: json['vote_count'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'overview': overview,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
        'first_air_date': firstAirDate,
        'genre_ids': genreIds != null
            ? List<dynamic>.from(genreIds!.map((x) => x))
            : null,
        'origin_country': originCountry != null
            ? List<dynamic>.from(originCountry!.map((x) => x))
            : null,
        'original_language': originalLanguage,
        'original_name': originalName,
        'popularity': popularity,
        'vote_average': voteAverage,
        'vote_count': voteCount,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        posterPath,
        backdropPath,
        firstAirDate,
        genreIds,
        originCountry,
        originalLanguage,
        originalName,
        popularity,
        voteAverage,
        voteCount,
      ];
}

extension TvShowModelMapper on TvShowModel {
  TvShow toEntity() => TvShow(
        id: id,
        name: name,
        overview: overview,
        posterPath: posterPath ?? '',
        backdropPath: backdropPath,
        airDate: firstAirDate,
        genreIds: genreIds,
        countries: originCountry,
        originalLanguage: originalLanguage,
        originalName: originalName,
        popularity: popularity,
        rating: voteAverage,
        ratingCount: voteCount,
      );
}
