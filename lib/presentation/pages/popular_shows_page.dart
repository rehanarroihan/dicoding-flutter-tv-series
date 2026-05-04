import 'package:ditonton/presentation/bloc/show/popular/popular_shows_bloc.dart';
import 'package:ditonton/presentation/widgets/show_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularShowsPage extends StatefulWidget {
  static const routeName = '/popular-shows';

  const PopularShowsPage({Key? key}) : super(key: key);

  @override
  _PopularShowsPageState createState() => _PopularShowsPageState();
}

class _PopularShowsPageState extends State<PopularShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PopularShowsBloc>().add(OnFetchPopularShows());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Shows')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularShowsBloc, PopularShowsState>(
          builder: (context, state) {
            if (state is PopularShowsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PopularShowsHasData) {
              return ListView.builder(
                itemBuilder: (context, index) => ShowCard(state.result[index]),
                itemCount: state.result.length,
              );
            } else if (state is PopularShowsError) {
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
