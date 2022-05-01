import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni/view/Pages/library_page_view.dart';
import 'package:uni/model/entities/book.dart';
import 'package:uni/view/Widgets/book_container.dart';
import 'package:uni/view/Widgets/library_search_header.dart';

import '../../../testable_widget.dart';

void main() {
  group('LibraryPage', () {
    testWidgets('When given an empty list', (WidgetTester tester) async {
      final widget = makeTestableWidget(child: LibrarySearch(books: <Book>[]));
      await tester.pumpWidget(widget);

      expect(find.byType(LibrarySearchHeader), findsOneWidget);
      expect(find.byType(BookContainer), findsNothing);
    });

    testWidgets('When a single book is given', (WidgetTester tester) async {
      final book = Book(
        title: 'Programming - principles and practice using C++',
        author: 'Stroustrup, Bjarne',
        unitsAvailable: 5,
        hasDigitalVersion: true,
        hasPhysicalVersion: true,
      );

      final widget =
          makeTestableWidget(child: LibrarySearch(books: <Book>[book]));
      await tester.pumpWidget(widget);

      expect(find.byType(LibrarySearchHeader), findsOneWidget);
      expect(find.byType(BookContainer), findsOneWidget);
      expect(find.byKey(Key('${book.toString()}-book')), findsOneWidget);
    });

    testWidgets('When given multiple books', (WidgetTester tester) async {
      final List<Book> books = [
        Book(
          title: 'Programming - principles and practice using C++',
          author: 'Stroustrup, Bjarne',
          unitsAvailable: 5,
          hasDigitalVersion: true,
          hasPhysicalVersion: true,
        ),
        Book(
          title: 'Modern condensed matter physics',
          author: 'Girvin, Steven M.',
          unitsAvailable: 3,
          hasDigitalVersion: false,
          hasPhysicalVersion: true,
        ),
        Book(
          title: 'Os 4 elementos',
          author: 'Pereira, Paulo',
          unitsAvailable: 1,
          hasDigitalVersion: true,
          hasPhysicalVersion: false,
        )
      ];

      final widget = makeTestableWidget(child: LibrarySearch(books: books));
      await tester.pumpWidget(widget);

      expect(find.byType(LibrarySearchHeader), findsOneWidget);
      expect(find.byType(BookContainer), findsWidgets);
      expect(find.byKey(Key('${books[0].toString()}-book')), findsOneWidget);
      expect(find.byKey(Key('${books[1].toString()}-book')), findsOneWidget);
      expect(find.byKey(Key('${books[2].toString()}-book')), findsOneWidget);
    });
  });
}
