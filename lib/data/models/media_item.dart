import 'package:photo_manager/photo_manager.dart';

enum MediaVaultStatus { freed, synced, vaulting, localOnly }

class MediaItem {
  final int id;
  final AssetEntity asset;
  final MediaVaultStatus status;

  const MediaItem({
    required this.id,
    required this.asset,
    required this.status,
  });

  String get title => asset.title ?? 'Untitled media';
  bool get isVideo => asset.type == AssetType.video;
  String get durationLabel {
    final seconds = asset.duration;
    if (seconds <= 0) return '';
    return '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  MediaItem copyWith({MediaVaultStatus? status}) => MediaItem(
        id: id,
        asset: asset,
        status: status ?? this.status,
      );
}
