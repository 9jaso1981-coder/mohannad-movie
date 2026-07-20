import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMoviesByYearParams {
  final int page;
  final int? year;
  const GetMoviesByYearParams({required this.page, this.year});
}

class GetMoviesByYear {
  final MovieRepository repository;
  GetMoviesByYear(this.repository);

  Future<Either<Failure, List<Movie>>> call(GetMoviesByYearParams params) {
    return repository.getMovies(page: params.page, year: params.year);
  }
}
