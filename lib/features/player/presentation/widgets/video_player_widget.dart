import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../domain/entities/stream_source.dart';

/// Plays a single [StreamSource] (a direct archive.org file URL) and lets
/// the user switch quality tiers, resuming at the same position.
class VideoPlayerWidget extends StatefulWidget {
  final List<StreamSource> sources;
  final StreamSource initialSource;
  final ValueChanged<StreamSource>? onQualityChanged;

  const VideoPlayerWidget({
    required this.sources,
    required this.initialSource,
    this.onQualityChanged,
    super.key,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final Player player;
  late final VideoController controller;
  late StreamSource current;

  @override
  void initState() {
    super.initState();
    current = widget.initialSource;
    player = Player();
    controller = VideoController(player);
    player.open(Media(current.url));
    WakelockPlus.enable();
  }

  Future<void> _switchQuality(StreamSource source) async {
    final position = player.state.position;
    await player.open(Media(source.url), play: true);
    await player.seek(position);
    setState(() => current = source);
    widget.onQualityChanged?.call(source);
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          Video(controller: controller),
          Positioned(
            bottom: 8,
            right: 8,
            child: _QualityMenu(
              sources: widget.sources,
              current: current,
              onSelected: _switchQuality,
            ),
          ),
        ],
      ),
    );
  }
}

class _QualityMenu extends StatelessWidget {
  final List<StreamSource> sources;
  final StreamSource current;
  final ValueChanged<StreamSource> onSelected;

  const _QualityMenu({
    required this.sources,
    required this.current,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<StreamSource>(
      initialValue: current,
      onSelected: onSelected,
      color: const Color(0xFF1A1A1A),
      itemBuilder: (context) => sources
          .map((s) => PopupMenuItem(
                value: s,
                child: Text(
                  s.label,
                  style: TextStyle(
                    color: s == current ? Theme.of(context).colorScheme.primary : Colors.white,
                    fontWeight: s == current ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hd, color: Colors.white, size: 18),
            const SizedBox(width: 4),
            Text(current.label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
