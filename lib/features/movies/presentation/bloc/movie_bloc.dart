import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movies_by_year.dart';
import '../../domain/usecases/search_movies.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetMoviesByYear getMoviesByYear;
  final SearchMovies searchMovies;

  MovieBloc({required this.getMoviesByYear, required this.searchMovies})
      : super(MovieInitial()) {
    on<FetchMoviesByYear>(_onFetchMoviesByYear);
    on<SearchMoviesEvent>(_onSearchMovies);
  }

  Future<void> _onFetchMoviesByYear(
      FetchMoviesByYear event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    final result = await getMoviesByYear(
      GetMoviesByYearParams(page: event.page, year: event.year),
    );
    result.fold(
      (failure) => emit(MovieError(failure.message)),
      (movies) => emit(MovieLoaded(movies)),
    );
  }

  Future<void> _onSearchMovies(
      SearchMoviesEvent event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    final result = await searchMovies(event.query);
    result.fold(
      (failure) => emit(MovieError(failure.message)),
      (movies) => emit(MovieLoaded(movies)),
    );
  }
}
