import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../player/domain/entities/stream_source.dart';
import '../entities/movie.dart';

abstract class MovieRepository {
  /// Discover public-domain titles, optionally filtered by [year] (1900–present).
  Future<Either<Failure, List<Movie>>> getMovies({required int page, int? year});

  Future<Either<Failure, List<Movie>>> searchMovies(String query, {int page = 1});

  /// Resolves the actual streamable file URLs + quality labels for a title
  /// by reading its archive.org metadata record.
  Future<Either<Failure, List<StreamSource>>> getStreamSources(String identifier);
}
