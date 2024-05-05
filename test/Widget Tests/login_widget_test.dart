import 'package:Testing/key_constants.dart';
import 'package:Testing/notifiers/quotes_notifier.dart';
import 'package:Testing/pages/login_screen.dart';
import 'package:Testing/services/quotes_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockQuotesService extends Mock implements QuotesService {}

void main() {
  testWidgets('Login Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: LoginScreen()),
      ),
    );

    expect(find.text('Login Screen'), findsOneWidget);

    expect(find.byKey((loginScreenTextKey)), findsOneWidget);
    expect(find.byKey(ValueKey('loginScreenTextKey')), findsOneWidget);
  });

  group('Challenge TO DO kazdy case rozbity do osobnego TC', () {
    testWidgets('Email Text Field is present', (WidgetTester tester) async {
      await tester
          .pumpWidget(ProviderScope(child: MaterialApp(home: LoginScreen())));
      expect(find.byKey(ValueKey('emailTextFormKey')), findsOneWidget);
    });
    testWidgets('Password text field', (WidgetTester tester) async {
      await tester
          .pumpWidget(ProviderScope(child: MaterialApp(home: LoginScreen())));
      expect(find.byKey(ValueKey('passwordTextFormKey')), findsOneWidget);
    });

    testWidgets('Login button', (WidgetTester tester) async {
      await tester
          .pumpWidget(ProviderScope(child: MaterialApp(home: LoginScreen())));
      expect(find.byKey((loginButtonTextKey)), findsOneWidget);
    });
  });
  group('Diferent Login Scenarios', () {
    final emailTextField = find.byKey(emailTextFormKey);
    final passwordTextField = find.byKey(passwordTextFormKey);
    final loginButton = find.byKey(loginButtonKey);

    final emailErrorText = find.text(kEmailErrorText);
    final passwordErrorText = find.text(kPasswordErrorText);

    testWidgets('Fail to login with invalid email and password',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(ProviderScope(child: MaterialApp(home: LoginScreen())));

      await tester.enterText(emailTextField, 'abcd');
      await tester.enterText(passwordTextField, 'haslo');

      await tester.tap(loginButton);

      await tester.pumpAndSettle();

      expect(emailErrorText, findsOneWidget);
      expect(passwordErrorText, findsOneWidget);
    });

    testWidgets('Error messages not shown after login with valid credentials',
        (WidgetTester tester) async {
      MockQuotesService mockQuotesService = MockQuotesService();

      await tester.pumpWidget(ProviderScope(
        overrides: [
          quotesNotifierProvider
              .overrideWith((ref) => QuotesNotifier(mockQuotesService)),
        ],
        child: MaterialApp(home: LoginScreen()),
      ));

      when(() => mockQuotesService.getQuotes())
          .thenAnswer((_) async => mockQuotesForTesting);

      await tester.enterText(emailTextField, 'example@wp.pl');
      await tester.enterText(passwordTextField, 'haslo123');

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(emailErrorText, findsNothing);
      expect(passwordErrorText, findsNothing);
    });

    testWidgets('Loading indicator is present after tapping on Login Button',
        (WidgetTester tester) async {
      MockQuotesService mockQuotesService = MockQuotesService();

      await tester.pumpWidget(ProviderScope(
        overrides: [
          quotesNotifierProvider
              .overrideWith((ref) => QuotesNotifier(mockQuotesService)),
        ],
        child: MaterialApp(home: LoginScreen()),
      ));

      when(() => mockQuotesService.getQuotes())
          .thenAnswer((_) async => mockQuotesForTesting);

      await tester.enterText(emailTextField, 'example@wp.pl');
      await tester.enterText(passwordTextField, 'haslo123');

      await tester.tap(loginButton);

      await tester.pump(const Duration(seconds: 1));
      expect(find.byKey(loginCircularProgressKey), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));

      expect(find.byKey(loginCircularProgressKey), findsNothing);
    });

    testWidgets('After login, user is navigating to All Quotes screen',
        (WidgetTester tester) async {
      MockQuotesService mockQuotesService = MockQuotesService();

      await tester.pumpWidget(ProviderScope(
        overrides: [
          quotesNotifierProvider
              .overrideWith((ref) => QuotesNotifier(mockQuotesService)),
        ],
        child: MaterialApp(home: LoginScreen()),
      ));

      when(() => mockQuotesService.getQuotes())
          .thenAnswer((_) async => mockQuotesForTesting);

      await tester.pumpAndSettle();

      await tester.enterText(emailTextField, 'example@wp.pl');
      await tester.enterText(passwordTextField, 'haslo123');

      await tester.tap(loginButton);

      await tester.pump(const Duration(seconds: 1));
      expect(find.byKey(loginCircularProgressKey), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      var quotesPageTitle = find.text('All Quotes');

      expect(quotesPageTitle, findsOneWidget);
    });
  });
}
