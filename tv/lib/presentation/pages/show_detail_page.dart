import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/entities/tv_show_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tv/presentation/bloc/detail/show_detail_bloc.dart';

class ShowDetailPage extends StatefulWidget {
  static const routeName = '/detail-show';
  final int id;

  const ShowDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _ShowDetailPageState createState() => _ShowDetailPageState();
}

class _ShowDetailPageState extends State<ShowDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ShowDetailBloc>().add(OnFetchShowDetail(widget.id));
      context.read<ShowDetailBloc>().add(OnLoadShowWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ShowDetailBloc, ShowDetailState>(
        builder: (context, state) {
          if (state.showDetailState == ShowDataState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.showDetailState == ShowDataState.loaded) {
            return SafeArea(
              child: ShowDetailContent(
                state.showDetail!,
                state.showRecommendations,
                state.isAddedToWatchlist,
              ),
            );
          } else if (state.showDetailState == ShowDataState.error) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Empty'));
          }
        },
      ),
    );
  }
}

class ShowDetailContent extends StatelessWidget {
  final TvShowDetail show;
  final List<TvShow> recommendations;
  final bool isInWatchlist;

  const ShowDetailContent(
    this.show,
    this.recommendations,
    this.isInWatchlist, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${show.posterPath}',
          width: width,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(show.name, style: kHeading5),
                            BlocListener<ShowDetailBloc, ShowDetailState>(
                              listenWhen: (previous, current) =>
                                  current.watchlistMessage !=
                                      previous.watchlistMessage &&
                                  current.watchlistMessage != '',
                              listener: (context, state) {
                                final message = state.watchlistMessage;
                                if (message ==
                                        ShowDetailBloc
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        ShowDetailBloc
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        AlertDialog(content: Text(message)),
                                  );
                                }
                              },
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (!isInWatchlist) {
                                    context
                                        .read<ShowDetailBloc>()
                                        .add(OnAddShowWatchlist(show));
                                  } else {
                                    context
                                        .read<ShowDetailBloc>()
                                        .add(OnRemoveShowFromWatchlist(show));
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    isInWatchlist
                                        ? const Icon(Icons.check)
                                        : const Icon(Icons.add),
                                    const Text('Watchlist'),
                                  ],
                                ),
                              ),
                            ),
                            Text(_formatGenres(show.genres)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: show.rating / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${show.rating}'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(
                              show.overview.isEmpty
                                  ? 'No overview available.'
                                  : show.overview,
                            ),
                            const SizedBox(height: 16),
                            Text('Recommendations', style: kHeading6),
                            _buildRecommendationList(),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child:
                          Container(color: Colors.white, height: 4, width: 48),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  String _formatGenres(List<Genre> genres) {
    return genres.map((g) => g.name).join(', ');
  }

  Widget _buildRecommendationList() {
    return BlocBuilder<ShowDetailBloc, ShowDetailState>(
      builder: (context, state) {
        if (state.showRecommendationsState == ShowDataState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.showRecommendationsState == ShowDataState.error) {
          return Text(state.message);
        } else if (state.showRecommendationsState == ShowDataState.loaded) {
          return Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final item = recommendations[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        ShowDetailPage.routeName,
                        arguments: item.id,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500${item.posterPath}',
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
              itemCount: recommendations.length,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
