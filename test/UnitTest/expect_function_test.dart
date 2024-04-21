import 'package:flutter_test/flutter_test.dart';
// TC sprawdzający czy aktualna wartość jest równa spodziewanej

void main() {
  // Pozytywny przypadek gdzie oba argumenty są sobie równe
  test('Positive test', () {
    expect(1, 1);
  });

// Negatywny przypadek poniewaz aktualny argument i oczekiwany są rózne
  test('Negative result', () {
    expect(1, 1);
  });
}
