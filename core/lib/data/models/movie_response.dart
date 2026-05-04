import 'package:core/data/models/movie_model.dart';
import 'package:equatable/equatable.dart';

class MovieResponse extends Equatable {
  final List<MovieModel> movieList;

  MovieResponse({required this.movieList});

  factory MovieResponse.fromJson(Map<String, dynamic> json) => MovieResponse(
        movieList: List<MovieModel>.from(
          (json['results'] as List)
              .map((x) => MovieModel.fromMap(x))
              .where((element) => element.posterPath != null),
        ),
      );

  Map<String, dynamic> toJson() => {
        'results': List<dynamic>.from(movieList.map((x) => x.toMap())),
      };

  @override
  List<Object> get props => [movieList];
}
