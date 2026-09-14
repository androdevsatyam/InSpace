import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/media_item.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/media_thumbnail.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= AppBreakpoints.tablet;
      return Obx(() => Scaffold(
            body: SafeArea(
                child: Row(children: [
              if (wide) _sideRail(context),
              Expanded(
                  child: IndexedStack(
                      index: controller.selectedTab.value,
                      children: [
                    _gallery(context),
                    _vault(context),
                    _search(context),
                    _profile(context),
                  ])),
            ])),
            bottomNavigationBar: wide ? null : _bottomNavigation(context),
          ));
    });
  }

  Widget _gallery(BuildContext context) => CustomScrollView(slivers: [
        SliverAppBar(floating: true, title: const _BrandTitle()),
        if (!controller.galleryPermissionGranted.value)
          SliverToBoxAdapter(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.page, 4, AppSpacing.page, 8),
                  child: _permissionCard(context))),
        SliverToBoxAdapter(child: _filterBar()),
        if (controller.isLoading.value)
          const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()))
        else if (controller.visibleItems.isEmpty)
          const SliverFillRemaining(
              child: Center(child: Text('No media found on this device.')))
        else
          SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.page),
              sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = controller.visibleItems[index];
                    return MediaThumbnail(
                        item: item, onTap: () => _showDetail(context, item));
                  }, childCount: controller.visibleItems.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: constraintsFor(context),
                      crossAxisSpacing: AppSpacing.grid,
                      mainAxisSpacing: AppSpacing.grid))),
      ]);

  int constraintsFor(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= AppBreakpoints.desktop
          ? 5
          : MediaQuery.sizeOf(context).width >= AppBreakpoints.tablet
              ? 4
              : 3;

  Widget _filterBar() => SizedBox(
      height: 52,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          scrollDirection: Axis.horizontal,
          children: [
            _chip('All Media', null),
            _chip('Cloud Freed', MediaVaultStatus.freed),
            _chip('Ready to Free', MediaVaultStatus.synced),
            _chip('Vaulting', MediaVaultStatus.vaulting),
            _chip('On Device', MediaVaultStatus.localOnly),
          ]));

  Widget _chip(String label, MediaVaultStatus? status) => Padding(
      padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
      child: Obx(() => FilterChip(
          label: Text(label),
          selected: controller.selectedFilter.value == status,
          onSelected: (_) => controller.selectFilter(status),
          selectedColor: AppColors.indigo,
          checkmarkColor: Colors.white)));

  Widget _vault(BuildContext context) => _sectionPage(
        context,
        'Storage & Vault',
        'Total phone space liberated and cloud breakdown',
        Column(children: [
          _infoCard(Icons.lock_outline_rounded, 'Private Cloud Vault',
              'Connect your account to back up media securely.'),
        ]),
      );

  Widget _search(BuildContext context) => _sectionPage(
        context,
        'Explore Media',
        'Search by faces, tags, or size',
        Column(children: [
          TextField(
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search 'Videos over 1 GB', 'Sunsets'...",
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none))),
          const SizedBox(height: 20),
          _infoCard(Icons.video_library_rounded, '4K UHD Videos',
              '38 files • 42.1 GB'),
          const SizedBox(height: 10),
          _infoCard(Icons.cloud_done_rounded, 'Freed from Phone',
              '284 files in private cloud'),
        ]),
      );

  Widget _profile(BuildContext context) => _sectionPage(
        context,
        'Account & Backup',
        'Manage your Google account and backup rules',
        Column(children: [
          if (controller.isSignedIn) ...[
            ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(controller.signedInUser.value!),
                subtitle: const Text('Google account connected')),
            const Divider(),
            _adaptiveToggle(context, 'Auto-Vault New Media', true),
            _adaptiveToggle(context, 'Backup on Wi-Fi Only', true),
            _adaptiveToggle(context, 'Only While Charging', false),
          ] else
            _signInCard(context),
        ]),
      );

  Widget _sectionPage(
          BuildContext context, String title, String subtitle, Widget child) =>
      ListView(padding: const EdgeInsets.all(AppSpacing.page), children: [
        const SizedBox(height: 12),
        Text(title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(subtitle,
            style: const TextStyle(color: AppColors.muted, fontSize: 12)),
        const SizedBox(height: 20),
        child
      ]);

  Widget _infoCard(IconData icon, String title, String subtitle,
          {Widget? action}) =>
      Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border)),
          child: Row(children: [
            Icon(icon, color: AppColors.emerald),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style:
                          const TextStyle(color: AppColors.muted, fontSize: 12))
                ])),
            if (action != null) action
          ]));

  Widget _permissionCard(BuildContext context) => _infoCard(
      Icons.photo_library_outlined,
      'Gallery access required',
      'Allow access to view media stored on this device.',
      action: TextButton(
          onPressed: controller.requestGalleryAccess,
          child: const Text('Allow access')));

  Widget _signInCard(BuildContext context) => _infoCard(
      Icons.account_circle_outlined,
      'Connect Google account',
      'Sign in when you are ready to enable private vault features.',
      action: FilledButton(
          onPressed: () => controller.signIn(), child: const Text('Sign in')));

  Widget _adaptiveToggle(BuildContext context, String label, bool value) =>
      ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(label),
          trailing: Theme.of(context).platform == TargetPlatform.iOS
              ? CupertinoSwitch(value: value, onChanged: (_) {})
              : Switch(value: value, onChanged: (_) {}));

  Widget _bottomNavigation(BuildContext context) => NavigationBar(
          selectedIndex: controller.selectedTab.value,
          onDestinationSelected: controller.selectTab,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.photo_library_outlined),
                selectedIcon: Icon(Icons.photo_library),
                label: 'Gallery'),
            NavigationDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2),
                label: 'Vault'),
            NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
            NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile')
          ]);

  Widget _sideRail(BuildContext context) => NavigationRail(
          selectedIndex: controller.selectedTab.value,
          onDestinationSelected: controller.selectTab,
          labelType: NavigationRailLabelType.all,
          destinations: const [
            NavigationRailDestination(
                icon: Icon(Icons.photo_library_outlined),
                selectedIcon: Icon(Icons.photo_library),
                label: Text('Gallery')),
            NavigationRailDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2),
                label: Text('Vault')),
            NavigationRailDestination(
                icon: Icon(Icons.search), label: Text('Search')),
            NavigationRailDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: Text('Profile'))
          ]);

  void _showDetail(BuildContext context, MediaItem item) =>
      showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          builder: (_) => Padding(
              padding: const EdgeInsets.all(AppSpacing.page),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    Text(item.isVideo ? 'Video' : 'Photo'),
                    Text(item.asset.createDateTime.toLocal().toString()),
                    const SizedBox(height: 20)
                  ])));
}

class _BrandTitle extends StatelessWidget {
  const _BrandTitle();
  @override
  Widget build(BuildContext context) => const Row(children: [
        Icon(Icons.all_inclusive_rounded, color: AppColors.emerald),
        SizedBox(width: 8),
        Text('InSpace')
      ]);
}
