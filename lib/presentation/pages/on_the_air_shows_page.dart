import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/on_the_air_shows_notifier.dart';
import 'package:ditonton/presentation/widgets/show_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      Provider.of<OnTheAirShowsNotifier>(context, listen: false).fetchShows();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currently Airing')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<OnTheAirShowsNotifier>(
          builder: (context, data, child) {
            if (data.status == RequestState.Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (data.status == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) => ShowCard(data.showList[index]),
                itemCount: data.showList.length,
              );
            } else {
              return Center(
                  child: Text(data.msg, key: const Key('error_message')));
            }
          },
        ),
      ),
    );
  }
}
