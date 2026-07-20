import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../domain/entities/movie.dart';
import '../pages/movie_detail_page.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
      ),
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: movie.thumbnailUrl,
                width: 130,
                height: 180,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: const Color(0xFF1A1A1A),
                  highlightColor: const Color(0xFF2A2A2A),
                  child: Container(width: 130, height: 180, color: Colors.black),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 130,
                  height: 180,
                  color: const Color(0xFF1A1A1A),
                  child: const Icon(Icons.movie_creation_outlined, color: Colors.white38),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (movie.year != null)
              Text(
                movie.year.toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white54),
              ),
          ],
        ),
      ),
    );
  }
}
