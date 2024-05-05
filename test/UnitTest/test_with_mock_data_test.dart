import 'package:Testing/key_constants.dart';
import 'package:Testing/models/quotes.dart';
import 'package:Testing/notifiers/quotes_notifier.dart';
import 'package:Testing/services/quotes_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/src/client.dart';
import 'package:mocktail/mocktail.dart';

/* Klasa symulowana MockQuotesService z wykorzystaniem paczki Mocktail, 
która sprawia, ze nie musimy implementować wszystkich metod klas */
class MockQuotesService extends Mock implements QuotesService {}

void main() {
  //sut (System Under Test) oznacza, ze testy pisane są dla klasy QuotesNotifier więc klasa ta jest systemem poddanym testowi
  late QuotesNotifier sut_quotesNotifier;
  /* Tworzymy zmienną klasy MockQuotesService bez zmiennej sut, poniewaz nie tworzymy
  systemu poddawanego testowi tylko tworzymy klasę symulowaną */

  late MockQuotesService mockQuotesService;

  /* Funkcja setUp jest wywoływana przed kazdym testem, mozemy napisać wspólny kod
  wewnątrz funkcji i zainicjować zmienne, które będą uzywane w teście */
  setUp(() {
    // Tworzymy obiekt klasy MockQuotesService i przekazujemy go do konstruktora QuotesNotifier
    mockQuotesService = MockQuotesService();
    sut_quotesNotifier = QuotesNotifier(mockQuotesService);
  });

  test('Check initial values are correct', () {
    expect(sut_quotesNotifier.isLoading, false);
    expect(sut_quotesNotifier.quotes, []);
  });

  group('getQuotes', () {
    /* Test czy funkcja getQuotes zwraca cytaty z QuotesService 
   Test jest pisany zgodnie z zasadą AAA (Arrange/Act/Assert)*/
    test(('getQuotes should call getQuotes function'), () async {
      /* Arrange -> ustawiamy mockQuotesService tak, aby zwracał pustą listę
      gdy wywoływana jest funkcja getQuotes */
      when(() => mockQuotesService.getQuotes()).thenAnswer((_) async => []);

      // Action -> wywołanie funkcji getQuotes
      await sut_quotesNotifier.getQuotes();

      // Assert -> weryfikacja czy funkcja getQuotes została wywołana raz
      verify(() => mockQuotesService.getQuotes()).called(1);
    });

    /* Test sprawdzający czy QuotesService jest wywoływany czy nie, oraz czy pola
    są aktualizowane poprawnie i dane są wypełnione */
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
    /* Powyższy test najpierw ustawia mockQuotesService tak, aby zwracał listę cytatów. 
    Następnie wywołuje funkcję getQuotes i przechowuje przyszłość w zmiennej. 
    Następnie sprawdza, czy isLoading jest true. 
    Następnie czeka na zakończenie przyszłości i sprawdza, czy cytaty są poprawnie wypełnione, a isLoading jest false. */
  });
}
