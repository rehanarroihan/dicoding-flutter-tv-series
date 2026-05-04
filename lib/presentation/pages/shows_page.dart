import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/on_the_air_shows_page.dart';
import 'package:ditonton/presentation/pages/popular_shows_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_shows_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/provider/on_the_air_shows_notifier.dart';
import 'package:ditonton/presentation/provider/popular_shows_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_shows_notifier.dart';
import 'package:ditonton/presentation/widgets/show_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      Provider.of<PopularShowsNotifier>(context, listen: false)
          .loadPopularShows();
      Provider.of<OnTheAirShowsNotifier>(context, listen: false).fetchShows();
      Provider.of<TopRatedShowsNotifier>(context, listen: false)
          .fetchTopRated();
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
              Consumer<OnTheAirShowsNotifier>(
                builder: (context, data, child) {
                  if (data.status == RequestState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (data.status == RequestState.Loaded) {
                    return ShowList(data.showList);
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
              Consumer<PopularShowsNotifier>(
                builder: (context, data, child) {
                  if (data.reqState == RequestState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (data.reqState == RequestState.Loaded) {
                    return ShowList(data.items);
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
              Consumer<TopRatedShowsNotifier>(
                builder: (context, data, child) {
                  if (data.state == RequestState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (data.state == RequestState.Loaded) {
                    return ShowList(data.list);
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
