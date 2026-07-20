import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String identifier; // archive.org unique id, e.g. "night_of_the_living_dead"
  final String title;
  final String description;
  final int? year;
  final String thumbnailUrl;
  final int downloads;
  final String? licenseUrl;

  const Movie({
    required this.identifier,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.downloads,
    this.year,
    this.licenseUrl,
  });

  @override
  List<Object?> get props =>
      [identifier, title, description, year, thumbnailUrl, downloads, licenseUrl];
}
