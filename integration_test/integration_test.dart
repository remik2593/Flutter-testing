import 'package:flutter_test/flutter_test.dart';

import '../test/Widget Tests/reuse_login_widget_test.dart';
import '../test/Widget Tests/reuse_quote_widget_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Integration Test', () {
    testWidgets('Login-Page', (tester) => loginWidgetTest(tester));
    testWidgets('All-Quotes-Page', (tester) => quoteWidgetTest(tester));
  });
}

// testy są odpalane w terminalu komenda: flutter test integration_test/integration_tests.dart
