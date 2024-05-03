// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/* Goldeny wymagają nazwy dla zrzutu ekranu. 
Stworzymy nową funkcję, która przyjmie nazwę widżetu i wygeneruje dla nas nazwę goldena
Funkcja getGoldenName pobiera nazwę strony, nazwę stanu i nazwę urządzenia oraz generuje dla nas nazwę goldenu*/
String getGoldenName(
        String page, String state, TestCaseScreenInfo testCaseScreenInfo) =>
    'goldens/$page-$state-${testCaseScreenInfo.deviceName}.png';

/* Tworzymy funkcję, która wygeneruje dla nas goldena z nazwą
Funkcja doGoldenGeneric pobiera typ widżetu, nazwę strony, nazwę stanu i nazwę urządzenia 
oraz generuje dla nas obraz golden. Tutaj nie wymieniliśmy typu widżetu. 
Możemy użyć tej funkcji do generowania golden dla dowolnego widżetu; dlatego nazywa się funkcją generyczną. */
Future doGoldenGeneric<T>(
        String page, String state, TestCaseScreenInfo testCaseScreenInfo) =>
    expectLater(find.byType(T),
        matchesGoldenFile(getGoldenName(page, state, testCaseScreenInfo)));

/* Jedyny problem z ponownym użyciem testWidget jako testu integracyjnego polega na tym, 
że test integracyjny nie powiedzie się, jeśli test widżetu generuje golden, 
ponieważ nie ma zrzutów ekranu do porównania
Tworzymy funkcję, aby generować golden tylko wtedy, gdy testCaseScreenInfo nie jest nullem.*/
Future doGolden(
        String page, String state, TestCaseScreenInfo? testCaseScreenInfo) =>
    testCaseScreenInfo != null
        ? doGoldenGeneric<MaterialApp>(page, state, testCaseScreenInfo)
        : Future.value();

// Tworzymy zmienne związane z testem na róznych urządzeniach
// Google Pixel 2
const double PIXEL_2_HEIGHT = 1920;
const double PIXEL_2_WIDTH = 1080;

// iphone 13
const double IPHONE_13_HEIGHT = 2532;
const double IPHONE_13_WIDTH = 1170;

// iphone 13 device pixel ratio
const double IPHONE_13_PIXEL_RATIO = 3.0;

// galaxy tab
const double GALAXY_TAB_HEIGHT = 2560;
const double GALAXY_TAB_WIDTH = 1600;

// ipad pro pixel ratio
const double IPAD_PRO_PIXEL_RATIO = 4.0;

// pixel 2 pixel ratio
const double PIXEL_2_PIXEL_RATIO = 2.625;

// ipad pro
const double IPAD_PRO_HEIGHT = 2732;
const double IPAD_PRO_WIDTH = 2048;

/* Tworzymy klasę, która będzie przechowywać informację
o rozmiarze ekranu i współczynniku pikseli, ułatwiając nam wywoływanie */
class TestCaseScreenInfo {
  final String deviceName;
  final Size screenSize;
  final double pixedRatio;
  final double textScaleValue;

  /* Zastosowanie required przed każdym parametrem konstruktora oznacza, 
  że te wartości muszą być dostarczone, inaczej będzie zgłoszony błąd kompilacji */
  const TestCaseScreenInfo(
      {required this.deviceName,
      required this.screenSize,
      required this.pixedRatio,
      required this.textScaleValue});
}

/* Tworzymy listę obiektów klasy TestCaseScreenInfo, która będzie przechowywać informacje 
o rozmiarze ekranu dla wszystkich urządzeń, które chcemy przetestować */

const testCaseScreenInfoList = [
  // Pixel 2 Portrait
  TestCaseScreenInfo(
      deviceName: 'Pixel-2-Portrait',
      screenSize: Size(PIXEL_2_WIDTH, PIXEL_2_HEIGHT),
      pixedRatio: PIXEL_2_PIXEL_RATIO,
      textScaleValue: 1.0),

  // Pixel 2 Landscape
  TestCaseScreenInfo(
      deviceName: 'Pixel-2-Landscape',
      screenSize: Size(PIXEL_2_HEIGHT, PIXEL_2_WIDTH),
      pixedRatio: PIXEL_2_PIXEL_RATIO,
      textScaleValue: 1.0),

  // iphone 13 Portrait
  TestCaseScreenInfo(
      deviceName: 'iphone-13-Portrait',
      screenSize: Size(IPHONE_13_WIDTH, IPHONE_13_HEIGHT),
      pixedRatio: IPHONE_13_PIXEL_RATIO,
      textScaleValue: 1.0),

  // iphone 13 Landscape
  TestCaseScreenInfo(
      deviceName: 'iphone-13-Landscape',
      screenSize: Size(IPHONE_13_HEIGHT, IPHONE_13_WIDTH),
      pixedRatio: IPHONE_13_PIXEL_RATIO,
      textScaleValue: 1.0),

  // ipad pro Portrait
  TestCaseScreenInfo(
      deviceName: 'ipad-pro-Portrait',
      screenSize: Size(IPAD_PRO_WIDTH, IPAD_PRO_HEIGHT),
      pixedRatio: IPAD_PRO_PIXEL_RATIO,
      textScaleValue: 1.0),

  // ipad pro Landscape
  TestCaseScreenInfo(
      deviceName: 'ipad-pro-Landscape',
      screenSize: Size(IPAD_PRO_HEIGHT, IPAD_PRO_WIDTH),
      pixedRatio: IPAD_PRO_PIXEL_RATIO,
      textScaleValue: 1.0),

  // galaxy tab Portrait
  TestCaseScreenInfo(
      deviceName: 'galaxy-tab-Portrait',
      screenSize: Size(GALAXY_TAB_WIDTH, GALAXY_TAB_HEIGHT),
      pixedRatio: IPAD_PRO_PIXEL_RATIO,
      textScaleValue: 1.0),

  // galaxy tab Landscape
  TestCaseScreenInfo(
      deviceName: 'galaxy-tab-Landscape',
      screenSize: Size(GALAXY_TAB_HEIGHT, GALAXY_TAB_WIDTH),
      pixedRatio: IPAD_PRO_PIXEL_RATIO,
      textScaleValue: 1.0),
];

extension WidgetTesterExtension on WidgetTester {
  Future setScreenSize(TestCaseScreenInfo testCaseScreenInfo) async {
    binding.platformDispatcher.textScaleFactorTestValue =
        testCaseScreenInfo.textScaleValue;
    binding.window.physicalSizeTestValue = testCaseScreenInfo.screenSize;
    binding.window.devicePixelRatioTestValue = testCaseScreenInfo.pixedRatio;

    addTearDown(binding.window.clearPhysicalSizeTestValue);
  }
}

Future testWidgetsMultipleScreenSizes(
        String testName,
        Future<void> Function(WidgetTester, TestCaseScreenInfo testCase)
            testFunction) async =>
    testCaseScreenInfoList.forEach((testCase) async {
      testWidgets("$testName-${testCase.deviceName}", (tester) async {
        await tester.setScreenSize(testCase);
        await testFunction(tester, testCase);
      });
    });
