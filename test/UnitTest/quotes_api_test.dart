import 'dart:io';

import 'package:Testing/key_constants.dart';
import 'package:Testing/models/quotes.dart';
import 'package:Testing/services/quotes_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test('quotes json test', () {
    final quote = Quotes(1, '', '');
    // Asercja testu
    expect(quote.id, 1);
    expect(quote.author, '');
    expect(quote.quote, '');
  });

// Test symulowanego serwisu API
  test('Quotes Service MOCK API Test', () async {
/* Teraz tworzymy funkcję _mockHTTP, która będzie symulować funkcję HTTP. 
   Podamy dane symulacyjne funkcji HTTP, które zostaną zwrócone, 
   gdy zostanie wysłane żądanie, abyśmy mogli je przetestować. Powyzszy kod sprawdzi, 
   czy URL żądania zaczyna się od URL-a API. Jeśli tak, zwróci dane symulacyjne. 
   W przeciwnym razie zostanie zgłoszony wyjątek. */
    Future<Response> _mockHttp(Request request) async {
      if (request.url.toString().startsWith('https://dummyjson.com/quotes')) {
        return Response(mockQuotes, 200,
            headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      }

      return throw Exception('failed');
    }

/* Tworzymy usługę API i przypisujemy ją do klasy QuoteService. 
   Klasa usługi z cytatami przyjmuje klienta jako argument. 
   Więc będziemy musieli utworzyć klienta mock. Użyjemy klasy MockClient z pakietu HTTP */
    final client = (MockClient(_mockHttp));
    final apiService = QuotesService(client);

/* Klient mockowy przyjmuje funkcję jako argument. 
   Ta funkcja zostanie wywołana, gdy klient wyśle żądanie. 
  Więc utwórzmy funkcję o nazwie _mockHTTP, która przyjmuje żądanie jako argument, 
   zwraca odpowiedź, przekazuje tę funkcję jako argument do klienta mockowego i wywołuje funkcję getQuotes. */
    final quotes = await apiService.getQuotes();

    expect(quotes.first.id, 1);
    expect(quotes.first.author, 'Shree');
    expect(quotes.first.quote, 'I am best');
  });
}
