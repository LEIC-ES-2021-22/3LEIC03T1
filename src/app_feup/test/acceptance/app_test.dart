import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

import 'steps/first_widget.dart';
import 'steps/navigate.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob('test/acceptance/features/**.feature')]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: 'test/acceptance/report.json')
    ]
    ..stepDefinitions = [navigate(), firstWidget()]
    ..customStepParameterDefinitions = []
    ..restartAppBetweenScenarios = true
    ..targetAppPath = 'test/acceptance/app.dart'
    ..defaultTimeout = Duration(seconds: 60);
  return GherkinRunner().execute(config);
}
