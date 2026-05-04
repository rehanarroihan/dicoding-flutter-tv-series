import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:equatable/equatable.dart';

class TvShowTable extends Equatable {
  final int id;
  final String? name;
  final String? posterPath;
  final String? overview;

  TvShowTable({
    required this.id,
    this.name,
    this.posterPath,
    this.overview,
  });

  factory TvShowTable.fromEntity(TvShowDetail show) => TvShowTable(
        id: show.id,
        name: show.name,
        posterPath: show.posterPath,
        overview: show.overview,
      );

  factory TvShowTable.fromMap(Map<String, dynamic> map) => TvShowTable(
        id: map['id'],
        name: map['title'],
        posterPath: map['posterPath'],
        overview: map['overview'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': name,
        'posterPath': posterPath,
        'overview': overview,
      };

  TvShow toEntity() => TvShow.watchlist(
        id: id,
        name: name ?? '',
        overview: overview ?? '',
        posterPath: posterPath ?? '',
      );

  @override
  List<Object?> get props => [id, name, posterPath, overview];
}
