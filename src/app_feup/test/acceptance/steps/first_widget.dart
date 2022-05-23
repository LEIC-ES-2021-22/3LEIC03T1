import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric firstWidget() {
  return when2<String, String, FlutterWorld>(
      'I tap the first descendant of {string} of type {string}',
      (parentKey, type, context) async {
    final widget = find.descendant(
        of: find.byValueKey(parentKey),
        matching: find.byType(type),
        firstMatchOnly: true);
    await FlutterDriverUtils.tap(context.world.driver, widget);
  });
}
