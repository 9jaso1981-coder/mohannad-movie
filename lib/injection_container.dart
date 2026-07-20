import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'features/movies/data/datasources/archive_org_remote_datasource.dart';
import 'features/movies/data/repositories/movie_repository_impl.dart';
import 'features/movies/domain/repositories/movie_repository.dart';
import 'features/movies/domain/usecases/get_movies_by_year.dart';
import 'features/movies/domain/usecases/get_stream_sources.dart';
import 'features/movies/domain/usecases/search_movies.dart';
import 'features/movies/presentation/bloc/movie_bloc.dart';
import 'features/player/presentation/bloc/player_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton(() => DioClient.create());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Data sources
  sl.registerLazySingleton<ArchiveOrgRemoteDataSource>(
    () => ArchiveOrgRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(sl(), sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMoviesByYear(sl()));
  sl.registerLazySingleton(() => SearchMovies(sl()));
  sl.registerLazySingleton(() => GetStreamSources(sl()));

  // Blocs — factory so each screen gets a fresh instance
  sl.registerFactory(
    () => MovieBloc(getMoviesByYear: sl(), searchMovies: sl()),
  );
  sl.registerFactory(() => PlayerBloc(sl()));
}
