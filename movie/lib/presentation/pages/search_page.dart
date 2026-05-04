import 'package:core/common/constants.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:core/presentation/widgets/show_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/search/movie_search_bloc.dart';
import 'package:tv/presentation/bloc/search/show_search_bloc.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  final bool isMovie;

  SearchPage({required this.isMovie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search ${isMovie ? 'Movie' : 'TV Show'}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                if (isMovie) {
                  context
                      .read<MovieSearchBloc>()
                      .add(OnMovieSearchQueryChanged(query));
                } else {
                  context
                      .read<ShowSearchBloc>()
                      .add(OnShowSearchQueryChanged(query));
                }
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            isMovie
                ? BlocBuilder<MovieSearchBloc, MovieSearchState>(
                    builder: (context, state) {
                      if (state is MovieSearchLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is MovieSearchHasData) {
                        final result = state.result;
                        return Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final movie = result[index];
                              return MovieCard(movie);
                            },
                            itemCount: result.length,
                          ),
                        );
                      } else if (state is MovieSearchError) {
                        return Expanded(
                          child: Center(child: Text(state.message)),
                        );
                      } else {
                        return Expanded(child: Container());
                      }
                    },
                  )
                : BlocBuilder<ShowSearchBloc, ShowSearchState>(
                    builder: (context, state) {
                      if (state is ShowSearchLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ShowSearchHasData) {
                        final result = state.result;
                        return Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final item = result[index];
                              return ShowCard(item);
                            },
                            itemCount: result.length,
                          ),
                        );
                      } else if (state is ShowSearchError) {
                        return Expanded(
                          child: Center(child: Text(state.message)),
                        );
                      } else {
                        return Expanded(child: Container());
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
