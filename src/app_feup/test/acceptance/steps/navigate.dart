import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';
import 'package:uni/utils/constants.dart' as Constants;

// Drawer must be open in order for navigate() to work
StepDefinitionGeneric navigate() {
  return given1<String, FlutterWorld>('I navigate to the {string} page',
      (page, context) async {
    String pageRoute;
    switch (page) {
      case 'librarySearch':
        pageRoute = Constants.navLibrary;
        break;
      default:
        pageRoute = Constants.navPersonalArea;
    }

    final pageFinder = find.text(pageRoute);
    await FlutterDriverUtils.tap(context.world.driver, pageFinder);
  });
}
