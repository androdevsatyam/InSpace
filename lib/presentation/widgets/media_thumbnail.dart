import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/media_item.dart';

class MediaThumbnail extends StatelessWidget {
  final MediaItem item;
  final VoidCallback onTap;
  const MediaThumbnail({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          child: Stack(fit: StackFit.expand, children: [
            FutureBuilder<Uint8List?>(
              future: item.asset
                  .thumbnailDataWithSize(const ThumbnailSize(600, 600)),
              builder: (context, snapshot) => snapshot.hasData
                  ? Image.memory(snapshot.data!, fit: BoxFit.cover)
                  : const ColoredBox(
                      color: AppColors.elevated,
                      child: Icon(Icons.photo_outlined)),
            ),
            if (item.status == MediaVaultStatus.vaulting)
              const ColoredBox(
                  color: Color(0x55000000),
                  child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.amber, strokeWidth: 2))),
            Positioned(
                top: 6, right: 6, child: _StatusBadge(status: item.status)),
            if (item.isVideo && item.durationLabel.isNotEmpty)
              Positioned(
                  bottom: 6,
                  left: 6,
                  child:
                      _glassPill(Icons.play_arrow_rounded, item.durationLabel)),
          ]),
        ),
      ),
    );
  }

  Widget _glassPill(IconData icon, String label) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            color: Colors.black.withOpacity(.66),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon, size: 13, color: Colors.white),
              const SizedBox(width: 2),
              Text(label,
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w700))
            ]),
          ),
        ),
      );
}

class _StatusBadge extends StatelessWidget {
  final MediaVaultStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (icon, label, color) = switch (status) {
      MediaVaultStatus.freed => (
          Icons.cloud_done_rounded,
          '0 MB',
          AppColors.emerald
        ),
      MediaVaultStatus.synced => (
          Icons.cloud_upload_outlined,
          'Ready',
          AppColors.blue
        ),
      MediaVaultStatus.vaulting => (
          Icons.sync_rounded,
          'Vaulting',
          AppColors.amber
        ),
      MediaVaultStatus.localOnly => (
          Icons.phone_android_rounded,
          'Local',
          AppColors.muted
        ),
    };
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(.72),
              border: Border.all(color: color.withOpacity(.55)),
              borderRadius: BorderRadius.circular(8)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 3),
            Text(label,
                style: TextStyle(
                    fontSize: 9, fontWeight: FontWeight.w700, color: color))
          ]),
        ),
      ),
    );
  }
}
