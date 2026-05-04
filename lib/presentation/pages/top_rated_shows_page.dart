import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/top_rated_shows_notifier.dart';
import 'package:ditonton/presentation/widgets/show_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      Provider.of<TopRatedShowsNotifier>(context, listen: false)
          .fetchTopRated();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated Shows')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TopRatedShowsNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) => ShowCard(data.list[index]),
                itemCount: data.list.length,
              );
            } else {
              return Center(
                  child:
                      Text(data.errorMessage, key: const Key('error_message')));
            }
          },
        ),
      ),
    );
  }
}
