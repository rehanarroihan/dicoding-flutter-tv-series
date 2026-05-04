import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/popular_shows_notifier.dart';
import 'package:ditonton/presentation/widgets/show_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      Provider.of<PopularShowsNotifier>(context, listen: false)
          .loadPopularShows();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Shows')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PopularShowsNotifier>(
          builder: (context, data, child) {
            if (data.reqState == RequestState.Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (data.reqState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) => ShowCard(data.items[index]),
                itemCount: data.items.length,
              );
            } else {
              return Center(
                  child: Text(data.errMsg, key: const Key('error_message')));
            }
          },
        ),
      ),
    );
  }
}
