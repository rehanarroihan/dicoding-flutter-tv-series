import 'package:ditonton/presentation/bloc/show/top_rated/top_rated_shows_bloc.dart';
import 'package:ditonton/presentation/widgets/show_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedShowsPage extends StatefulWidget {
  static const routeName = '/top-rated-shows';

  const TopRatedShowsPage({Key? key}) : super(key: key);

  @override
  _TopRatedShowsPageState createState() => _TopRatedShowsPageState();
}

class _TopRatedShowsPageState extends State<TopRatedShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TopRatedShowsBloc>().add(OnFetchTopRatedShows());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated Shows')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedShowsBloc, TopRatedShowsState>(
          builder: (context, state) {
            if (state is TopRatedShowsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TopRatedShowsHasData) {
              return ListView.builder(
                itemBuilder: (context, index) => ShowCard(state.result[index]),
                itemCount: state.result.length,
              );
            } else if (state is TopRatedShowsError) {
              return Center(
                  child: Text(state.message, key: const Key('error_message')));
            } else {
              return const Center(child: Text('Empty'));
            }
          },
        ),
      ),
    );
  }
}
