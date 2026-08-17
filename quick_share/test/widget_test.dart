import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quick_share/core/theme/theme_provider.dart';
import 'package:quick_share/core/providers/profile_provider.dart';
import 'package:quick_share/main.dart';
import 'package:quick_share/core/constants/storage_keys.dart';

void main() {
  testWidgets('Splash screen renders title and tagline', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
          ChangeNotifierProvider(create: (_) => ProfileProvider(prefs)),
        ],
        child: const QuickShareApp(),
      ),
    );

    expect(find.text('QuickShare'), findsOneWidget);
    expect(find.text('Your Offline Digital Card'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });

  testWidgets('App landing shows Create Form when no profiles are saved', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
          ChangeNotifierProvider(create: (_) => ProfileProvider(prefs)),
        ],
        child: const QuickShareApp(),
      ),
    );

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Create Profile Card'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Professional Title'), findsOneWidget);
    expect(find.text('Primary URL'), findsOneWidget);
  });

  testWidgets('App landing shows PageView with multiple profile cards', (WidgetTester tester) async {
    final String profileJson1 = jsonEncode({
      'id': '1',
      'name': 'Jane Smith',
      'title': 'Software Architect',
      'url': 'https://janesmith.dev',
    });
    final String profileJson2 = jsonEncode({
      'id': '2',
      'name': 'Bob Johnson',
      'title': 'Product Designer',
      'url': 'https://bjohnson.design',
    });

    SharedPreferences.setMockInitialValues({
      StorageKeys.profilesList: [profileJson1, profileJson2],
      StorageKeys.activeProfileIndex: 0,
    });
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
          ChangeNotifierProvider(create: (_) => ProfileProvider(prefs)),
        ],
        child: const QuickShareApp(),
      ),
    );

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Verify first profile is shown initially
    expect(find.text('Jane Smith'), findsOneWidget);
    expect(find.text('Software Architect'), findsOneWidget);
    expect(find.text('https://janesmith.dev'), findsOneWidget);
    expect(find.text('Card 1 of 2'), findsOneWidget);

    // Verify second profile is not yet on screen (or out of view)
    // PageView pre-renders, but active text checks can verify pagination headers
    expect(find.text('Card 2 of 2'), findsNothing);
  });
}
