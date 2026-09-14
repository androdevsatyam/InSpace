import 'package:flutter/material.dart';
import 'dart:ui';

enum MediaVaultStatus {
  freed,     // Safe in cloud, 0 MB local space used
  synced,    // Safe in cloud, original still taking space on device
  vaulting,  // Uploading / compressing in background
  localOnly, // On device only, queued for backup
}

class MediaItemCard extends StatelessWidget {
  final String imageUrl;
  final MediaVaultStatus status;
  final String? videoDuration;
  final String? spaceSavedText;
  final VoidCallback onTap;

  const MediaItemCard({
    super.key,
    required this.imageUrl,
    required this.status,
    this.videoDuration,
    this.spaceSavedText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Media Thumbnail Image
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF1E293B),
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),

              // Gradient Overlay at bottom for readable text
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black87, Colors.transparent],
                    ),
                  ),
                ),
              ),

              // TOP-RIGHT: NOTICEABLE STATUS BADGE
              Positioned(
                top: 6,
                right: 6,
                child: _buildStatusBadge(),
              ),

              // BOTTOM: Video Duration & Space Metric
              if (videoDuration != null || spaceSavedText != null)
                Positioned(
                  bottom: 6,
                  left: 6,
                  right: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (videoDuration != null)
                        _buildGlassPill(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.play_arrow_rounded, size: 14, color: Colors.redAccent),
                              const SizedBox(width: 2),
                              Text(
                                videoDuration!,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      if (spaceSavedText != null && status == MediaVaultStatus.freed)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF064E3B).withOpacity(0.85),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            spaceSavedText!,
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF6EE7B7)),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    switch (status) {
      case MediaVaultStatus.freed:
        return _buildGlassPill(
          borderColor: const Color(0xFF10B981).withOpacity(0.4),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_done_rounded, size: 13, color: Color(0xFF10B981)),
              SizedBox(width: 3),
              Text(
                '0 MB',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF6EE7B7)),
              ),
            ],
          ),
        );

      case MediaVaultStatus.synced:
        return _buildGlassPill(
          borderColor: const Color(0xFF3B82F6).withOpacity(0.4),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_upload_outlined, size: 13, color: Color(0xFF3B82F6)),
              SizedBox(width: 3),
              Text(
                'Ready',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF93C5FD)),
              ),
            ],
          ),
        );

      case MediaVaultStatus.vaulting:
        return _buildGlassPill(
          borderColor: const Color(0xFFF59E0B).withOpacity(0.4),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
                ),
              ),
              SizedBox(width: 4),
              Text(
                'Vaulting',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFFCD34D)),
              ),
            ],
          ),
        );

      case MediaVaultStatus.localOnly:
        return _buildGlassPill(
          borderColor: Colors.white24,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.phone_android_rounded, size: 12, color: Colors.white70),
              SizedBox(width: 2),
              Text(
                'Local',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white70),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildGlassPill({required Widget child, Color? borderColor}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withOpacity(0.78),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor ?? Colors.white12, width: 0.8),
          ),
          child: child,
        ),
      ),
    );
  }
}

