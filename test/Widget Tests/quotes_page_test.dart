import 'package:Testing/key_constants.dart';
import 'package:Testing/notifiers/quotes_notifier.dart';
import 'package:Testing/pages/all_quotes_screen.dart';
import 'package:Testing/services/quotes_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/* Tworzymy klasę aby móc mockować pobieranie cytatów do testów, w których 
musi być wysłane zapytanie HTTP */
class MockQuotesService extends Mock implements QuotesService {}

void main() {
  MockQuotesService mockQuotesService = MockQuotesService();

  /* Musimy zwrócić mockowane cytaty, gdy wywoływana jest funkcja getQuotes(). 
  Stwórzmy funkcję, która zastąpi prawdziwe cytaty mockami. 
  Dodamy opóźnienie dwóch sekund, aby odwzorować scenariusz rzeczywisty */
  void getQuotesAfter2SecondsDelay() {
    when(() => mockQuotesService.getQuotes()).thenAnswer((_) async {
      return await Future.delayed(
          const Duration(seconds: 2), () => mockQuotesForTesting);
    });
  }

  /* Tworzymy funkcję o nazwie createWidgetUnderTest, która zwraca widżet. 
  Ta funkcja będzie używana do tworzenia drzewa widżetów dla testu. 
  Wywołamy tę funkcję wewnątrz metody pumpWidget */
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

  // Wywołanie funkcji mockującej cytaty
  getQuotesAfter2SecondsDelay();

  // POWYŻSZA KONFIGURACJA DOTYCZY SETUPU POD TESTY

  group('Quote screen tests', () {
    testWidgets('All Quotes Widget test', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      /* Wywołujemy metode pumpAndSettle zeby wszyskie asynchroniczne operacje 
    zostały zakończone */
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.text('All Quotes'), findsOneWidget);
    });

    testWidgets('Loading indicator is present in widget tree',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      /* Funkcja 'pump' przyjmuje czas trwania jako argument. 
      Czas trwania to czas, który chcesz poczekać na zakończenie animacji. */
      await tester.pump(const Duration(seconds: 1));
      expect(find.byKey(quotesCircularProgressKey), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));

      expect(find.byKey(quotesCircularProgressKey), findsNothing);
    });

    testWidgets('Quotes are present in the widget tree',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pump(const Duration(seconds: 1));
      expect(find.byKey(quotesCircularProgressKey), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));

      expect(find.byKey(quotesCircularProgressKey), findsNothing);
      expect(find.text('Test Quote 1'), findsOneWidget);
      expect(find.text('Test Quote 2'), findsOneWidget);
      expect(find.text('Test Quote 3'), findsOneWidget);
    });

    testWidgets('Happy Path for Quote screen', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // TC 1 Quote screen tests
      expect(find.text('All Quotes'), findsOneWidget);

      // TC 2 Loading indicator is present in widget tree
      await tester.pump(const Duration(seconds: 1));
      expect(find.byKey(quotesCircularProgressKey), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(find.byKey(quotesCircularProgressKey), findsNothing);

      // TC3 Quotes are present in the widget tree
      expect(find.text('Test Quote 1'), findsOneWidget);
      expect(find.text('Test Quote 2'), findsOneWidget);
      expect(find.text('Test Quote 3'), findsOneWidget);
    });
  });
}
