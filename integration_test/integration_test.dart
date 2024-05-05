import 'package:flutter_test/flutter_test.dart';

import '../test/Widget Tests/reuse_login_widget_test.dart';
import '../test/Widget Tests/reuse_quote_widget_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  /* Przed uruchomieniem testu integracyjnego musimy upewnić się, że nasze widżety Flutter są gotowe. 
  Dlatego musimy wywołać funkcję WidgetsFlutterBinding.ensureInitialized() przed uruchomieniem testu integracyjnego */
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Integration Test', () {
    // Wywołujemy przekształcony widzet jako funkcję wewnątrz testu integracyjnego
    testWidgets('Login-Page', (tester) => loginWidgetTest(tester));
    testWidgets('All-Quotes-Page', (tester) => quoteWidgetTest(tester));
  });
}

// testy są odpalane w terminalu komenda: flutter test integration_test/integration_test.dart
// Aktualnie testy nie odpalają się na emulatorach jak równie urządzeniach mobilnych
// temat do weryfikacji po zakończonym kursie !!!