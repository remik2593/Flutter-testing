import 'package:Testing/key_constants.dart';
import 'package:Testing/models/quotes.dart';
import 'package:Testing/notifiers/quotes_notifier.dart';
import 'package:Testing/services/quotes_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/src/client.dart';
import 'package:mocktail/mocktail.dart';

class MockQuotesService extends Mock implements QuotesService {}

void main() {
  late QuotesNotifier sut_quotesNotifier;
  late MockQuotesService mockQuotesService;

  /* ZMIANY WZGLĘDEM TESTOW PISANYCH W test_with_mock_data.dart:
  mockQuotesForTesting -> przekazuje listę cytatów
  arrageQuotesServiceReturnsQuotes uzywamy tam, gdzie potrzebujemy skonfigurować 
  mockQuotesService tak, aby zwracał listę cytatów. */

  setUp(() {
    mockQuotesService = MockQuotesService();
    sut_quotesNotifier = QuotesNotifier(mockQuotesService);
  });

  test('Should check initial values are correct', () {
    expect(sut_quotesNotifier.isLoading, false);
    expect(sut_quotesNotifier.quotes, []);
  });

  group('getQuotes', () {
    void arrageQuotesServiceReturnsQuotes() {
      when(() => mockQuotesService.getQuotes())
          .thenAnswer((_) async => mockQuotesForTesting);
    }

    test('Get Quotes using the QuotesService', () async {
      arrageQuotesServiceReturnsQuotes();
      await sut_quotesNotifier.getQuotes();
      verify(() => mockQuotesService.getQuotes()).called(1);
    });

    test('''Loading data indicator, 
      sets quotes, indicates data is not loaded anymore''', () async {
      arrageQuotesServiceReturnsQuotes();
      final future = sut_quotesNotifier.getQuotes();
      expect(sut_quotesNotifier.isLoading, true);
      await future;
      expect(sut_quotesNotifier.quotes, mockQuotesForTesting);
      expect(sut_quotesNotifier.isLoading, false);
    });
  });
}
