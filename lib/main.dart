import 'package:about/about.dart';
import 'package:core/core.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SSLPinning.init();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<MovieSearchBloc>()),
        BlocProvider(create: (_) => di.locator<NowPlayingMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMovieBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<OnTheAirShowsBloc>()),
        BlocProvider(create: (_) => di.locator<PopularShowsBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedShowsBloc>()),
        BlocProvider(create: (_) => di.locator<ShowSearchBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistShowsBloc>()),
        BlocProvider(create: (_) => di.locator<ShowDetailBloc>()),
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
                builder: (_) => const PopularShowsPage(),
              );
            case OnTheAirShowsPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const OnTheAirShowsPage(),
              );
            case TopRatedShowsPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const TopRatedShowsPage(),
              );
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
