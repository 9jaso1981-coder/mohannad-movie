import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../../player/presentation/widgets/video_player_widget.dart';
import '../../domain/entities/movie.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;
  const MovieDetailPage({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayerBloc(context.read())..add(LoadStreamSources(movie.identifier)),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  imageUrl: movie.thumbnailUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(color: const Color(0xFF1A1A1A)),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    if (movie.year != null)
                      Text(
                        '${movie.year} · Public Domain',
                        style: const TextStyle(color: Colors.white54),
                      ),
                    const SizedBox(height: 16),
                    BlocBuilder<PlayerBloc, PlayerState>(
                      builder: (context, state) {
                        if (state is PlayerLoading || state is PlayerInitial) {
                          return const AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (state is PlayerError) {
                          return AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              color: const Color(0xFF1A1A1A),
                              child: Center(
                                child: Text(state.message, textAlign: TextAlign.center),
                              ),
                            ),
                          );
                        }
                        if (state is PlayerReady) {
                          return VideoPlayerWidget(
                            sources: state.sources,
                            initialSource: state.current,
                            onQualityChanged: (source) =>
                                context.read<PlayerBloc>().add(ChangeQuality(source)),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 20),
                    Text('Overview', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(
                      movie.description.isEmpty
                          ? 'No description available.'
                          : movie.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
