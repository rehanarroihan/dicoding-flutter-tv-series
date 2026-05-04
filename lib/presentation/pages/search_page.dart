import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/show_search_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/show_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              onSubmitted: (query) {
                if (isMovie) {
                  Provider.of<MovieSearchNotifier>(context, listen: false)
                      .fetchMovieSearch(query);
                } else {
                  Provider.of<ShowSearchNotifier>(context, listen: false)
                      .executeSearch(query);
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
                ? Consumer<MovieSearchNotifier>(
                    builder: (context, data, child) {
                      if (data.state == RequestState.Loading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (data.state == RequestState.Loaded) {
                        final result = data.searchResult;
                        return Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final movie = data.searchResult[index];
                              return MovieCard(movie);
                            },
                            itemCount: result.length,
                          ),
                        );
                      } else {
                        return Expanded(child: Container());
                      }
                    },
                  )
                : Consumer<ShowSearchNotifier>(
                    builder: (context, data, child) {
                      if (data.searchStatus == RequestState.Loading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (data.searchStatus == RequestState.Loaded) {
                        final result = data.results;
                        return Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final item = data.results[index];
                              return ShowCard(item);
                            },
                            itemCount: result.length,
                          ),
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
