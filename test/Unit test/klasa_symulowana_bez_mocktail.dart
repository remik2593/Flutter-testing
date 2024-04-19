// Klasa symulowana zawierająca mockowane dane klasy QuotesService

/*class MockQuotesService implements QuotesService {
// Kiedy rozszerzamy lub implementujemy klasę, musimy zaimplementować wszystkie metody klasy.
//W naszym przypadku musimy zaimplementować metodę getQuotes. Można to zrobić wybierając opcje Create Missing overrides
  @override
  Client get client => throw UnimplementedError();

// Dodanie funkcji, która będzie zwracać fałszywe dane
  @override
  Future<List<Quotes>> getQuotes() async {
// W tej funkcji zwracamy przewidywalne dane cytatów, które stworzylismy ponizej
    return [
      Quotes(1, 'Test Quote 1', 'Test Author 1'),
      Quotes(2, 'Test Quote 2', 'Test Author 2'),
      Quotes(3, 'Test Quote 3', 'Test Author 3'),
    ];
  }
}*/
