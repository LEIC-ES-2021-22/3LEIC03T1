import 'package:flutter_test/flutter_test.dart';
import 'package:uni/view/Widgets/library_search_header.dart';
import 'package:uni/view/Widgets/search_filter_form.dart';

import '../../../testable_widget.dart';

void main() {
  group('LibrarySearchHeader', () {
    testWidgets('Filter options appear after clicking in the icon',
        (WidgetTester tester) async {
      final widget = makeTestableWidget(child: LibrarySearchHeader());
      await tester.pumpWidget(widget);
      expect(find.byType(SearchFilterForm), findsNothing);

      await tester.tap(find.byTooltip('Filtros de Pesquisa'));
      await tester.pump();
      expect(find.byType(SearchFilterForm), findsOneWidget);
    });

    testWidgets('Filter options close after clicking on confirm',
        (WidgetTester tester) async {
      final widget = makeTestableWidget(child: LibrarySearchHeader());
      await tester.pumpWidget(widget);

      await tester.tap(find.byTooltip('Filtros de Pesquisa'));
      await tester.pump();
      await tester.tap(find.text('Confirmar'));

      await tester.pump();
      expect(find.byType(SearchFilterForm), findsNothing);
    });

    testWidgets('Filter options close after clicking on cancel',
        (WidgetTester tester) async {
      final widget = makeTestableWidget(child: LibrarySearchHeader());
      await tester.pumpWidget(widget);

      await tester.tap(find.byTooltip('Filtros de Pesquisa'));
      await tester.pump();
      await tester.tap(find.text('Cancelar'));

      await tester.pump();
      expect(find.byType(SearchFilterForm), findsNothing);
    });

    // TODO Test if clicking on 'Reservas' changes page
  });
}
