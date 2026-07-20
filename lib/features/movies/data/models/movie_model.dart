import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.identifier,
    required super.title,
    required super.description,
    required super.thumbnailUrl,
    required super.downloads,
    super.year,
    super.licenseUrl,
  });

  /// Parses one "doc" object from archive.org's advancedsearch.php response.
  factory MovieModel.fromArchiveDoc(Map<String, dynamic> json) {
    final identifier = json['identifier'] as String? ?? '';
    int? year;
    final rawYear = json['year'];
    if (rawYear is int) {
      year = rawYear;
    } else if (rawYear is String) {
      year = int.tryParse(rawYear);
    } else if (rawYear is List && rawYear.isNotEmpty) {
      year = int.tryParse(rawYear.first.toString());
    }

    return MovieModel(
      identifier: identifier,
      title: (json['title'] ?? 'Untitled').toString(),
      description: (json['description'] ?? '').toString(),
      thumbnailUrl: ApiConstants.thumbnailFor(identifier),
      downloads: (json['downloads'] is int) ? json['downloads'] as int : 0,
      year: year,
      licenseUrl: json['licenseurl']?.toString(),
    );
  }
}
