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

  setUp(() {
    mockQuotesService = MockQuotesService();
    sut_quotesNotifier = QuotesNotifier(mockQuotesService);
  });

  test('Check initial values are correct', () {
    expect(sut_quotesNotifier.isLoading, false);
    expect(sut_quotesNotifier.quotes, []);
  });

  group('getQuotes', () {
    test(('getQuotes should call getQuotes function'), () async {
      when(() => mockQuotesService.getQuotes()).thenAnswer((_) async => []);

      await sut_quotesNotifier.getQuotes();

      verify(() => mockQuotesService.getQuotes()).called(1);
    });

    test('''Loading data indicator, 
  sets quotes, indicates data is not loaded anymore''', () async {
      when(() => mockQuotesService.getQuotes())
          .thenAnswer((_) async => mockQuotesForTesting);
      final future = sut_quotesNotifier.getQuotes();
      expect(sut_quotesNotifier.isLoading, true);
      await future;
      expect(sut_quotesNotifier.quotes, mockQuotesForTesting);
      expect(sut_quotesNotifier.isLoading, false);
    });
  });
}
