import 'package:get/get.dart';
import '../../data/models/media_item.dart';
import '../../data/repositories/media_repository.dart';
import '../../data/services/auth_service.dart';

class HomeController extends GetxController {
  final MediaRepository repository;
  final AuthService authService;

  HomeController({required this.repository, required this.authService});

  final items = <MediaItem>[].obs;
  final selectedTab = 0.obs;
  final selectedFilter = Rxn<MediaVaultStatus>();
  final isLoading = false.obs;
  final galleryPermissionGranted = false.obs;
  final signedInUser = Rxn<String>();

  List<MediaItem> get visibleItems => selectedFilter.value == null
      ? items
      : items.where((item) => item.status == selectedFilter.value).toList();

  Future<void> requestGalleryAccess() async {
    isLoading.value = true;
    final granted = await repository.requestGalleryPermission();
    galleryPermissionGranted.value = granted;
    if (!granted) {
      items.clear();
      isLoading.value = false;
      return;
    }
    await loadMediaAfterPermission();
    isLoading.value = false;
  }

  Future<void> loadMediaAfterPermission() async {
    items.assignAll(await repository.fetchMedia());
  }

  Future<void> loadMedia() async {
    isLoading.value = true;
    final granted = await repository.requestGalleryPermission();
    galleryPermissionGranted.value = granted;
    if (!granted) {
      items.clear();
      isLoading.value = false;
      return;
    }

    items.assignAll(await repository.fetchMedia());
    isLoading.value = false;
  }

  bool get isSignedIn =>
      signedInUser.value != null && signedInUser.value!.isNotEmpty;

  Future<void> signIn() async {
    final account = await authService.signIn();
    signedInUser.value = account?.email;
  }

  Future<void> signOut() async {
    await authService.signOut();
    signedInUser.value = null;
  }

  void selectFilter(MediaVaultStatus? status) => selectedFilter.value = status;
  void selectTab(int index) => selectedTab.value = index;
}
