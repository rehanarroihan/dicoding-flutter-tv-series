import 'package:core/presentation/widgets/show_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/on_the_air/on_the_air_shows_bloc.dart';

class OnTheAirShowsPage extends StatefulWidget {
  static const routeName = '/on-the-air-shows';

  const OnTheAirShowsPage({Key? key}) : super(key: key);

  @override
  _OnTheAirShowsPageState createState() => _OnTheAirShowsPageState();
}

class _OnTheAirShowsPageState extends State<OnTheAirShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OnTheAirShowsBloc>().add(OnFetchOnTheAirShows());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currently Airing')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnTheAirShowsBloc, OnTheAirShowsState>(
          builder: (context, state) {
            if (state is OnTheAirShowsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OnTheAirShowsHasData) {
              return ListView.builder(
                itemBuilder: (context, index) => ShowCard(state.result[index]),
                itemCount: state.result.length,
              );
            } else if (state is OnTheAirShowsError) {
              return Center(
                child: Text(state.message, key: const Key('error_message')),
              );
            } else {
              return const Center(child: Text('Empty'));
            }
          },
        ),
      ),
    );
  }
}
