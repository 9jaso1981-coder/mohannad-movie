import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../player/domain/entities/stream_source.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/archive_org_remote_datasource.dart';

class MovieRepositoryImpl implements MovieRepository {
  final ArchiveOrgRemoteDataSource remote;
  final NetworkInfo networkInfo;

  MovieRepositoryImpl(this.remote, this.networkInfo);

  @override
  Future<Either<Failure, List<Movie>>> getMovies({required int page, int? year}) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final movies = await remote.discoverMovies(page: page, year: year);
      return Right(movies);
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query, {int page = 1}) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final movies = await remote.searchMovies(query, page: page);
      return Right(movies);
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<StreamSource>>> getStreamSources(String identifier) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final sources = await remote.getStreamSources(identifier);
      return Right(sources);
    } on NoStreamException {
      return const Left(NoStreamFailure());
    } on ServerException {
      return const Left(ServerFailure());
    }
  }
}
