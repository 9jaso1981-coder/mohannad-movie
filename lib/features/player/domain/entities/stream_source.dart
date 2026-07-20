import 'package:equatable/equatable.dart';

/// Represents one playable file variant for a title, e.g. different
/// resolutions/formats that archive.org exposes per upload (h.264 HD,
/// 512kb MPEG4, Ogv, etc). We label these the same way the app's quality
/// selector expects ("1080p", "720p", "480p") based on the file's tagged
/// height/bitrate where available.
class StreamSource extends Equatable {
  final String label; // "1080p" | "720p" | "480p" | "Auto"
  final String url;
  final String format; // e.g. "h.264", "512Kb MPEG4", "Ogv"

  const StreamSource({required this.label, required this.url, required this.format});

  @override
  List<Object?> get props => [label, url, format];
}
