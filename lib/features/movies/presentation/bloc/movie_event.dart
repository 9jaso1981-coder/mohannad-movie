part of 'movie_bloc.dart';

sealed class MovieEvent extends Equatable {
  const MovieEvent();
  @override
  List<Object?> get props => [];
}

class FetchMoviesByYear extends MovieEvent {
  final int page;
  final int? year;
  const FetchMoviesByYear({required this.page, this.year});
  @override
  List<Object?> get props => [page, year];
}

class SearchMoviesEvent extends MovieEvent {
  final String query;
  const SearchMoviesEvent(this.query);
  @override
  List<Object?> get props => [query];
}
