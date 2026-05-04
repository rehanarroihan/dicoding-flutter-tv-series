import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/on_the_air_shows_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_shows_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/show_detail_page.dart';
import 'package:ditonton/presentation/pages/shows_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_shows_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/on_the_air_shows_notifier.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/popular_shows_notifier.dart';
import 'package:ditonton/presentation/provider/show_detail_notifier.dart';
import 'package:ditonton/presentation/provider/show_search_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_shows_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_shows_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.locator<MovieListNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<MovieDetailNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<MovieSearchNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<TopRatedMoviesNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<PopularMoviesNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<WatchlistMovieNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<PopularShowsNotifier>()),
        ChangeNotifierProvider(create: (_) => di.locator<ShowDetailNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<OnTheAirShowsNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<TopRatedShowsNotifier>()),
        ChangeNotifierProvider(create: (_) => di.locator<ShowSearchNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<WatchlistShowsNotifier>()),
      ],
      child: MaterialApp(
        title: 'Ditonton',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeMoviePage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              final isMovie = settings.arguments as bool;
              return CupertinoPageRoute(
                builder: (_) => SearchPage(isMovie: isMovie),
                settings: settings,
              );
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case ShowsPage.routeName:
              return MaterialPageRoute(builder: (_) => const ShowsPage());
            case ShowDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => ShowDetailPage(id: id),
                settings: settings,
              );
            case PopularShowsPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => const PopularShowsPage());
            case OnTheAirShowsPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => const OnTheAirShowsPage());
            case TopRatedShowsPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => const TopRatedShowsPage());
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return const Scaffold(
                    body: Center(child: Text('Page not found')),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
