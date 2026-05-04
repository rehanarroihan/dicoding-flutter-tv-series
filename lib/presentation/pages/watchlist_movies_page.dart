import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_shows_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/show_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<WatchlistMovieNotifier>(context, listen: false)
          .fetchWatchlistMovies();
      Provider.of<WatchlistShowsNotifier>(context, listen: false)
          .loadWatchlist();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Provider.of<WatchlistMovieNotifier>(context, listen: false)
        .fetchWatchlistMovies();
    Provider.of<WatchlistShowsNotifier>(context, listen: false).loadWatchlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Movies', style: kHeading6),
              const SizedBox(height: 8.0),
              Consumer<WatchlistMovieNotifier>(
                builder: (context, data, child) {
                  if (data.watchlistState == RequestState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (data.watchlistState == RequestState.Loaded) {
                    return data.watchlistMovies.isEmpty
                        ? const Text('Empty')
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                                MovieCard(data.watchlistMovies[index]),
                            itemCount: data.watchlistMovies.length,
                          );
                  } else {
                    return Center(
                        key: const Key('error_message'),
                        child: Text(data.message));
                  }
                },
              ),
              const SizedBox(height: 8.0),
              Text('TV Shows', style: kHeading6),
              const SizedBox(height: 8.0),
              Consumer<WatchlistShowsNotifier>(
                builder: (context, data, child) {
                  if (data.watchlistState == RequestState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (data.watchlistState == RequestState.Loaded) {
                    return data.watchlistItems.isEmpty
                        ? const Text('Empty')
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                                ShowCard(data.watchlistItems[index]),
                            itemCount: data.watchlistItems.length,
                          );
                  } else {
                    return Center(
                        key: const Key('error_message'), child: Text(data.err));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
