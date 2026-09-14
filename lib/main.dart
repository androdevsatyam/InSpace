import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/media_repository.dart';
import 'data/services/api_service.dart';
import 'data/services/auth_service.dart';
import 'presentation/controllers/home_controller.dart';
import 'presentation/views/home/home_view.dart';

void main() {
  Get.put(HomeController(
    repository: MediaRepository(apiService: ApiService()),
    authService: AuthService(),
  ));
  runApp(const InSpaceApp());
}

class InSpaceApp extends StatelessWidget {
  const InSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'InSpace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: AppRoutes.home,
      getPages: [GetPage(name: AppRoutes.home, page: () => const HomeView())],
    );
  }
}
