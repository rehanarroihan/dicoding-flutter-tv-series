import 'package:core/data/models/genre_model.dart';
import 'package:core/domain/entities/tv_show_detail.dart';
import 'package:equatable/equatable.dart';

class TvShowDetailModel extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final List<GenreModel> genres;
  final double voteAverage;
  final int numberOfSeasons;
  final int numberOfEpisodes;

  TvShowDetailModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.genres,
    required this.voteAverage,
    required this.numberOfSeasons,
    required this.numberOfEpisodes,
  });

  factory TvShowDetailModel.fromMap(Map<String, dynamic> json) =>
      TvShowDetailModel(
        id: json['id'],
        name: json['name'],
        overview: json['overview'],
        posterPath: json['poster_path'],
        genres: List<GenreModel>.from(
          json['genres'].map((x) => GenreModel.fromJson(x)),
        ),
        voteAverage: json['vote_average']?.toDouble() ?? 0.0,
        numberOfSeasons: json['number_of_seasons'],
        numberOfEpisodes: json['number_of_episodes'],
      );

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        posterPath,
        genres,
        voteAverage,
        numberOfSeasons,
        numberOfEpisodes,
      ];
}

extension TvShowDetailMapper on TvShowDetailModel {
  TvShowDetail toEntity() => TvShowDetail(
        id: id,
        name: name,
        overview: overview,
        posterPath: posterPath,
        genres: genres.map((x) => x.toEntity()).toList(),
        rating: voteAverage,
        seasonCount: numberOfSeasons,
        episodeCount: numberOfEpisodes,
      );
}
