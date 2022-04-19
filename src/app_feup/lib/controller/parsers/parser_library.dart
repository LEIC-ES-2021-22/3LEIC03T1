import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/book.dart';

//import 'package:web_scraper/web_scraper.dart';

final int authorInfoIdx = 2;
final int titleInfoIdx = 3;
final int yearInfoIdx = 4;
final int documentTypeIdx = 5;
final int imagePathIdx = 7;
final int digitalInfoIdx = 9;

class ParserLibrary {
  Future<Set<Book>> parseBooksFromHtml(http.Response response) async {
    final document = parse(response.body);

    final Set<Book> booksList = Set();

    // get the book section (<tr valign=baseline>)
    document.querySelectorAll('tr[valign=baseline]').forEach((Element element) {
      final String author =
          element.querySelector('td:nth-child($authorInfoIdx)').text;
      // check this title
      final String title =
          element.querySelector('td:nth-child($titleInfoIdx)').text;
      final String date =
          element.querySelector('td:nth-child($yearInfoIdx)').text;
      final String documentType =
          element.querySelector('td:nth-child($documentTypeIdx)').text;
      final String imagePath =
          element.querySelector('td:nth-child($imagePathIdx)') != null
              ? element.querySelector('td:nth-child($imagePathIdx)').text
              : '';
      // check the return of this.
      final bool digitalAvailable =
          element.querySelector('td:nth-child($digitalInfoIdx)') != null
              ? true
              : false;
      final String digitalInfo =
          element.querySelector('td:nth-child($digitalInfoIdx)') != null
              ? element.querySelector('td:nth-child($digitalInfoIdx)').text
              : '';

      final Book book = Book(author, title, date, imagePath, digitalAvailable,
          digitalInfo, documentType);
      booksList.add(book);
    });

    return booksList;
  }
}
