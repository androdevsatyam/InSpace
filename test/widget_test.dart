// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:inspace/main.dart';
import 'package:inspace/data/repositories/media_repository.dart';
import 'package:inspace/data/services/api_service.dart';
import 'package:inspace/data/services/auth_service.dart';
import 'package:inspace/presentation/controllers/home_controller.dart';

void main() {
  test('repository exposes gallery permission request', () async {
    final repository = MediaRepository(apiService: ApiService());
    expect(repository.requestGalleryPermission(), completion(isA<bool>()));
  });

  testWidgets('renders InSpace', (WidgetTester tester) async {
    Get.put(HomeController(
        repository: MediaRepository(apiService: ApiService()),
        authService: AuthService()));
    await tester.pumpWidget(const InSpaceApp());
    await tester.pump();

    expect(find.text('InSpace'), findsOneWidget);
  });
}
