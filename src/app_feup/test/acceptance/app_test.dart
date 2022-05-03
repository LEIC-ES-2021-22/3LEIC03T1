import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

import 'steps/navigate.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob('test/acceptance/features/**.feature')]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: 'test/acceptance/report.json')
    ]
    ..stepDefinitions = [navigate()]
    ..customStepParameterDefinitions = []
    ..restartAppBetweenScenarios = true
    ..targetAppPath = 'test/acceptance/app.dart';
  return GherkinRunner().execute(config);
}
