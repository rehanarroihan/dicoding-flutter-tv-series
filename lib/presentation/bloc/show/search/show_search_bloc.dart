import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/search_shows.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

part 'show_search_event.dart';
part 'show_search_state.dart';

class ShowSearchBloc extends Bloc<ShowSearchEvent, ShowSearchState> {
  final SearchShows _searchShows;

  ShowSearchBloc(this._searchShows) : super(ShowSearchEmpty()) {
    on<OnShowSearchQueryChanged>((event, emit) async {
      final query = event.query;

      emit(ShowSearchLoading());
      final result = await _searchShows.execute(query);

      result.fold(
        (failure) {
          emit(ShowSearchError(failure.message));
        },
        (data) {
          emit(ShowSearchHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounce(duration).switchMap(mapper);
  }
}
