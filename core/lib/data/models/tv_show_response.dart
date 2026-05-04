import 'package:core/data/models/tv_show_model.dart';
import 'package:equatable/equatable.dart';

class TvShowResponse extends Equatable {
  final List<TvShowModel> items;

  TvShowResponse({required this.items});

  factory TvShowResponse.fromMap(Map<String, dynamic> json) => TvShowResponse(
        items: List<TvShowModel>.from(
          (json['results'] as List)
              .map((x) => TvShowModel.fromMap(x))
              .where((element) => element.posterPath != null),
        ),
      );

  Map<String, dynamic> toMap() => {
        'results': List<dynamic>.from(items.map((x) => x.toMap())),
      };

  @override
  List<Object?> get props => [items];
}
