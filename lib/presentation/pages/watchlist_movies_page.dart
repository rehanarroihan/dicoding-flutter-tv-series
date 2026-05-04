import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/show/watchlist/watchlist_shows_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/show_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      context.read<WatchlistMovieBloc>().add(OnFetchWatchlistMovies());
      context.read<WatchlistShowsBloc>().add(OnFetchWatchlistShows());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistMovieBloc>().add(OnFetchWatchlistMovies());
    context.read<WatchlistShowsBloc>().add(OnFetchWatchlistShows());
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
              BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
                builder: (context, state) {
                  if (state is WatchlistMovieLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WatchlistMovieHasData) {
                    return state.result.isEmpty
                        ? const Text('Empty')
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                                MovieCard(state.result[index]),
                            itemCount: state.result.length,
                          );
                  } else if (state is WatchlistMovieError) {
                    return Center(
                        key: const Key('error_message'),
                        child: Text(state.message));
                  } else {
                    return const Text('Empty');
                  }
                },
              ),
              const SizedBox(height: 8.0),
              Text('TV Shows', style: kHeading6),
              const SizedBox(height: 8.0),
              BlocBuilder<WatchlistShowsBloc, WatchlistShowsState>(
                builder: (context, state) {
                  if (state is WatchlistShowsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WatchlistShowsHasData) {
                    return state.result.isEmpty
                        ? const Text('Empty')
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                                ShowCard(state.result[index]),
                            itemCount: state.result.length,
                          );
                  } else if (state is WatchlistShowsError) {
                    return Center(
                        key: const Key('error_message'),
                        child: Text(state.message));
                  } else {
                    return const Text('Empty');
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
