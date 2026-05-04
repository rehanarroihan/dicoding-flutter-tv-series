import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/show/on_the_air/on_the_air_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/show/popular/popular_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/show/top_rated/top_rated_shows_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/on_the_air_shows_page.dart';
import 'package:ditonton/presentation/pages/popular_shows_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_shows_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/widgets/show_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowsPage extends StatefulWidget {
  static const routeName = '/shows';

  const ShowsPage({Key? key}) : super(key: key);

  @override
  _ShowsPageState createState() => _ShowsPageState();
}

class _ShowsPageState extends State<ShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OnTheAirShowsBloc>().add(OnFetchOnTheAirShows());
      context.read<PopularShowsBloc>().add(OnFetchPopularShows());
      context.read<TopRatedShowsBloc>().add(OnFetchTopRatedShows());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.blueGrey),
              currentAccountPicture: CircleAvatar(
                backgroundImage: const AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: const Text('Ditonton'),
              accountEmail: const Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () =>
                  Navigator.pushNamed(context, HomeMoviePage.ROUTE_NAME),
            ),
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('TV Series'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () =>
                  Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME),
            ),
            ListTile(
              onTap: () => Navigator.pushNamed(context, AboutPage.ROUTE_NAME),
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('TV Series'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, SearchPage.ROUTE_NAME,
                arguments: false),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'Airing Today',
                onTap: () =>
                    Navigator.pushNamed(context, OnTheAirShowsPage.routeName),
              ),
              BlocBuilder<OnTheAirShowsBloc, OnTheAirShowsState>(
                builder: (context, state) {
                  if (state is OnTheAirShowsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is OnTheAirShowsHasData) {
                    return ShowList(state.result);
                  } else {
                    return const Text('Failed to load');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularShowsPage.routeName),
              ),
              BlocBuilder<PopularShowsBloc, PopularShowsState>(
                builder: (context, state) {
                  if (state is PopularShowsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PopularShowsHasData) {
                    return ShowList(state.result);
                  } else {
                    return const Text('Failed to load');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedShowsPage.routeName),
              ),
              BlocBuilder<TopRatedShowsBloc, TopRatedShowsState>(
                builder: (context, state) {
                  if (state is TopRatedShowsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TopRatedShowsHasData) {
                    return ShowList(state.result);
                  } else {
                    return const Text('Failed to load');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
                children: [Text('See More'), Icon(Icons.arrow_forward_ios)]),
          ),
        ),
      ],
    );
  }
}
