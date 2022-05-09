import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni/model/entities/book.dart';
import 'package:uni/view/Widgets/book_container.dart';

import '../../../testable_widget.dart';

void main() {
  group('BookContainer', () {
    final basicBook = Book(
      title: 'Programming - principles and practice using C++',
      author: 'Stroustrup, Bjarne',
      unitsAvailable: 5,
      hasDigitalVersion: true,
      hasPhysicalVersion: true,
    );

    final physicalBook = Book(
      title: 'Programming - principles and practice using C++',
      author: 'Stroustrup, Bjarne',
      unitsAvailable: 5,
      hasDigitalVersion: false,
      hasPhysicalVersion: true,
    );

    final digitalBook = Book(
      title: 'Programming - principles and practice using C++',
      author: 'Stroustrup, Bjarne',
      unitsAvailable: 5,
      hasDigitalVersion: true,
      hasPhysicalVersion: false,
    );

    final unavailableBook = Book(
      title: 'Programming - principles and practice using C++',
      author: 'Stroustrup, Bjarne',
      unitsAvailable: 0,
      hasDigitalVersion: false,
      hasPhysicalVersion: false,
    );

    testWidgets('Book basic information appears in the container',
        (WidgetTester tester) async {
      final widget = makeTestableWidget(
          child: BookContainer(book: basicBook));
      await tester.pumpWidget(widget);

      expect(find.text(basicBook.title), findsOneWidget);
      expect(find.text(basicBook.author), findsOneWidget);
      expect(find.text(basicBook.getUnitsText()), findsOneWidget);

      expect(find.byIcon(Icons.file_download), findsOneWidget);
      expect(find.byIcon(Icons.menu_book), findsOneWidget);
    });

    testWidgets('Book placeholder is used when the image is not provided',
        (WidgetTester tester) async {
      final widget = makeTestableWidget(
          child: BookContainer(book: basicBook));
      await tester.pumpWidget(widget);

      // TODO: How to verify image path?
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets(
        'Only digital version indicator appears when physical not specified',
        (WidgetTester tester) async {
      final widget = makeTestableWidget(
          child: BookContainer(book: digitalBook));
      await tester.pumpWidget(widget);

      expect(find.byIcon(Icons.file_download), findsOneWidget);
      expect(find.byIcon(Icons.menu_book), findsNothing);
    });

    testWidgets(
        'Only physical version indicator appears when digital not specified',
        (WidgetTester tester) async {
      final widget = makeTestableWidget(
          child: BookContainer(book: physicalBook));
      await tester.pumpWidget(widget);

      expect(find.byIcon(Icons.menu_book), findsOneWidget);
      expect(find.byIcon(Icons.file_download), findsNothing);
    });

    testWidgets('No indicators appear when no version is available',
        (WidgetTester tester) async {
      final widget = makeTestableWidget(
          child: BookContainer(book: unavailableBook));
      await tester.pumpWidget(widget);

      expect(find.byIcon(Icons.menu_book), findsNothing);
      expect(find.byIcon(Icons.file_download), findsNothing);
    });
  });
}
