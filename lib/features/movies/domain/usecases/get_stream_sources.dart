import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../player/domain/entities/stream_source.dart';
import '../repositories/movie_repository.dart';

class GetStreamSources {
  final MovieRepository repository;
  GetStreamSources(this.repository);

  Future<Either<Failure, List<StreamSource>>> call(String identifier) {
    return repository.getStreamSources(identifier);
  }
}
