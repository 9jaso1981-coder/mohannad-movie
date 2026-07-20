/// Internet Archive endpoints — free, keyless, no registration required.
/// Docs: https://archive.org/advancedsearch.php
class ApiConstants {
  static const String searchEndpoint = 'https://archive.org/advancedsearch.php';
  static const String metadataEndpoint = 'https://archive.org/metadata';
  static const String thumbnailEndpoint = 'https://archive.org/services/img'; // + /{identifier}

  /// Collections curated as public-domain film sources on the Archive.
  /// Combine collection filters with a license check downstream for safety.
  static const List<String> publicDomainCollections = [
    'publicdomainmovies',
    'classic_tv',
    'feature_films',
    'moviesandfilms',
  ];

  /// Builds a search query for public-domain movies within a year range,
  /// paginated, sorted by (approximate) popularity via download count.
  static String discoverQuery({
    required int page,
    int rowsPerPage = 24,
    int? year,
    String mediaType = 'movies',
  }) {
    final collectionClause =
        'collection:(${publicDomainCollections.join(' OR ')})';
    final yearClause = year != null ? ' AND year:$year' : ' AND year:[1900 TO 2026]';
    final query = '$collectionClause AND mediatype:$mediaType$yearClause';

    final fields = [
      'identifier',
      'title',
      'description',
      'year',
      'avg_rating',
      'downloads',
    ].map((f) => 'fl[]=$f').join('&');

    return '$searchEndpoint?q=${Uri.encodeComponent(query)}'
        '&$fields'
        '&sort[]=downloads+desc'
        '&rows=$rowsPerPage'
        '&page=$page'
        '&output=json';
  }

  static String searchByTitle(String title, {int page = 1}) {
    final query = 'title:($title) AND mediatype:movies';
    return '$searchEndpoint?q=${Uri.encodeComponent(query)}'
        '&fl[]=identifier&fl[]=title&fl[]=description&fl[]=year&fl[]=downloads'
        '&rows=24&page=$page&output=json';
  }

  static String metadataFor(String identifier) => '$metadataEndpoint/$identifier';

  static String thumbnailFor(String identifier) => '$thumbnailEndpoint/$identifier';
}
