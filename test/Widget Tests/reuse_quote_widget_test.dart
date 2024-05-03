import 'package:Testing/key_constants.dart';
import 'package:Testing/notifiers/quotes_notifier.dart';
import 'package:Testing/pages/all_quotes_screen.dart';
import 'package:Testing/services/quotes_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockQuotesService extends Mock implements QuotesService {}

void main() {
  testWidgets('Quote Widget Test', quoteWidgetTest);
}

Future<void> quoteWidgetTest(WidgetTester tester) async {
  MockQuotesService mockQuotesService = MockQuotesService();
  Widget createWidgetUnderTest() {
    return ProviderScope(
        overrides: [
          quotesNotifierProvider
              .overrideWith((ref) => QuotesNotifier(mockQuotesService))
        ],
        child: MaterialApp(
          home: AllQuotesScreen(),
        ));
  }

  void getQuotesAfter2SecondsDelay() {
    when(() => mockQuotesService.getQuotes()).thenAnswer((_) async {
      return await Future.delayed(
          const Duration(seconds: 2), () => mockQuotesForTesting);
    });
  }

  getQuotesAfter2SecondsDelay();
  await tester.pumpWidget(createWidgetUnderTest());
  expect(find.text('All Quotes'), findsOneWidget);

  await tester.pump(Duration(seconds: 1));
  expect(find.byKey(quotesCircularProgressKey), findsOneWidget);
  await tester.pump(Duration(seconds: 1));
  expect(find.byKey(quotesCircularProgressKey), findsNothing);

  expect(find.text('Test Quote 1'), findsOneWidget);
  expect(find.text('Test Quote 2'), findsOneWidget);
  expect(find.text('Test Quote 3'), findsOneWidget);
}
