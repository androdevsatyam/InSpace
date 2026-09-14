import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';

import '../models/media_item.dart';
import '../services/api_service.dart';

class MediaRepository {
  final ApiService apiService;

  MediaRepository({required this.apiService});

  Future<bool> requestGalleryPermission() async {
    try {
      final permission = await PhotoManager.requestPermissionExtend();
      return permission.hasAccess;
    } on MissingPluginException {
      return false;
    }
  }

  Future<List<MediaItem>> fetchMedia() async {
    try {
      final paths = await PhotoManager.getAssetPathList(
        type: RequestType.common,
        onlyAll: true,
      );
      if (paths.isEmpty) return [];

      final assets = await paths.first.getAssetListPaged(page: 0, size: 100);
      return assets
          .map((asset) => MediaItem(
              id: asset.id.hashCode,
              asset: asset,
              status: MediaVaultStatus.localOnly))
          .toList();
    } on MissingPluginException {
      return [];
    }
  }
}
