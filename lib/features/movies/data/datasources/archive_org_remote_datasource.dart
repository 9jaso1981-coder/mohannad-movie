import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../player/domain/entities/stream_source.dart';
import '../models/movie_model.dart';

abstract class ArchiveOrgRemoteDataSource {
  Future<List<MovieModel>> discoverMovies({required int page, int? year});
  Future<List<MovieModel>> searchMovies(String query, {int page = 1});
  Future<List<StreamSource>> getStreamSources(String identifier);
}

class ArchiveOrgRemoteDataSourceImpl implements ArchiveOrgRemoteDataSource {
  final Dio dio;
  ArchiveOrgRemoteDataSourceImpl(this.dio);

  @override
  Future<List<MovieModel>> discoverMovies({required int page, int? year}) async {
    final url = ApiConstants.discoverQuery(page: page, year: year);
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      final docs = response.data['response']['docs'] as List;
      return docs
          .map((doc) => MovieModel.fromArchiveDoc(doc as Map<String, dynamic>))
          .where((m) => m.identifier.isNotEmpty)
          .toList();
    }
    throw ServerException();
  }

  @override
  Future<List<MovieModel>> searchMovies(String query, {int page = 1}) async {
    final url = ApiConstants.searchByTitle(query, page: page);
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      final docs = response.data['response']['docs'] as List;
      return docs
          .map((doc) => MovieModel.fromArchiveDoc(doc as Map<String, dynamic>))
          .where((m) => m.identifier.isNotEmpty)
          .toList();
    }
    throw ServerException();
  }

  /// Reads an item's metadata record and maps its video files to quality
  /// labels. Archive.org typically exposes several derivative files per
  /// upload (e.g. original + "512Kb MPEG4" + "h.264" + "Ogv"); we bucket
  /// these into the app's standard quality tiers using file name/height hints.
  @override
  Future<List<StreamSource>> getStreamSources(String identifier) async {
    final response = await dio.get(ApiConstants.metadataFor(identifier));
    if (response.statusCode != 200) throw ServerException();

    final files = (response.data['files'] as List?) ?? [];
    final server = response.data['server'] ?? response.data['d1'];
    final dir = response.data['dir'];

    final sources = <StreamSource>[];

    for (final f in files) {
      final name = f['name']?.toString() ?? '';
      final format = f['format']?.toString() ?? '';
      final isVideo = name.endsWith('.mp4') ||
          name.endsWith('.ogv') ||
          name.endsWith('.m4v') ||
          name.endsWith('.webm');
      if (!isVideo || server == null || dir == null) continue;

      final fileUrl = 'https://$server$dir/${Uri.encodeComponent(name)}';
      final label = _labelForFormat(format, f['height']);
      sources.add(StreamSource(label: label, url: fileUrl, format: format));
    }

    if (sources.isEmpty) throw NoStreamException();

    // De-duplicate by label, keep first occurrence, ensure a sensible order.
    final seen = <String>{};
    final unique = <StreamSource>[];
    for (final s in sources) {
      if (seen.add(s.label)) unique.add(s);
    }
    unique.sort((a, b) => _qualityRank(b.label).compareTo(_qualityRank(a.label)));
    return unique;
  }

  String _labelForFormat(String format, dynamic height) {
    final h = int.tryParse(height?.toString() ?? '');
    if (h != null) {
      if (h >= 1080) return '1080p';
      if (h >= 720) return '720p';
      if (h >= 480) return '480p';
      return 'SD';
    }
    final f = format.toLowerCase();
    if (f.contains('512kb')) return '480p';
    if (f.contains('h.264') || f.contains('mpeg4')) return '720p';
    if (f.contains('ogv') || f.contains('ogg')) return 'SD';
    return 'Auto';
  }

  int _qualityRank(String label) {
    switch (label) {
      case '1080p':
        return 3;
      case '720p':
        return 2;
      case '480p':
        return 1;
      default:
        return 0;
    }
  }
}
