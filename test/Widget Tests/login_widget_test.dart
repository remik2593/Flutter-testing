import 'package:Testing/key_constants.dart';
import 'package:Testing/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: LoginScreen()),
      ),
    );
    /* W testach widżetów równiez mamy funkcję "expect" do sprawdzenia, czy widżet jest obecny w drzewie widżetów. 
    Funkcja "expect" przyjmuje dwa argumenty. 
    Pierwszym argumentem jest widżet, który chcesz znaleźć, a drugim jest matcher. 
    Matcher to funkcja sprawdzająca, czy widżet jest obecny w drzewie widżetów.
    Poniej widzimy 3 rózne asercje dla tego samego zasobu*/
    expect(find.text('Login Screen'), findsOneWidget);
    /* Innym sposobem na znalezienie widżetu jest użycie funkcji find.byKey. 
    Ta funkcja przyjmuje klucz jako argument i zwraca widżet. 
    Jeśli widżet jest obecny w drzewie widżetów, zwróci widżet, w przeciwnym razie zwróci null. 
    Równie używamy matchera findsOneWidget, które sprawdza, czy widżet jest obecny w drzewie widżetów. 
    Jeśli widżet jest obecny, test zostanie zaliczony, w przeciwnym razie test nie zostanie zaliczony.*/
    expect(find.byKey((loginScreenTextKey)), findsOneWidget);
    expect(find.byKey(ValueKey('loginScreenTextKey')), findsOneWidget);
  });

  group('Challenge TO DO kazdy case rozbity do osobnego TC', () {
    testWidgets('Email Text Field is present', (WidgetTester tester) async {
      await tester
          .pumpWidget(ProviderScope(child: MaterialApp(home: LoginScreen())));
      expect(find.byKey(ValueKey('emailTextFormKey')), findsOneWidget);
    });
    testWidgets('Password text field', (WidgetTester tester) async {
      await tester
          .pumpWidget(ProviderScope(child: MaterialApp(home: LoginScreen())));
      expect(find.byKey(ValueKey('passwordTextFormKey')), findsOneWidget);
    });

    testWidgets('Login button', (WidgetTester tester) async {
      await tester
          .pumpWidget(ProviderScope(child: MaterialApp(home: LoginScreen())));
      expect(find.byKey((loginButtonTextKey)), findsOneWidget);
    });
  });
  group('Diferent Login Scenarios', () {
    final emailTextField = find.byKey(emailTextFormKey);
    final loginText = find.byKey(loginScreenTextKey);
    final passwordTextField = find.byKey(passwordTextFormKey);
    final loginButton = find.byKey(loginButtonKey);

    testWidgets('Fail to login with invalid email and password',
        (WidgetTester tester) async {
      await tester.enterText(emailTextField, 'abcd');
      await tester.enterText(passwordTextField, 'dupa12');
      await tester.tap(loginButton);

      await tester.pumpAndSettle();
      // lekcję 11 zacznij od 1 minutyffdsfsfddsfsfdfdfdsfssfdsadsdsa
    });
  });
}
