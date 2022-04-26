import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:uni/model/entities/book.dart';

//import 'package:web_scraper/web_scraper.dart';

final int authorInfoIdx = 2;
final int titleInfoIdx = 3;
final int yearInfoIdx = 4;
final int documentTypeIdx = 5;
final int imagePathIdx = 7;
final int digitalAvailableIdx = 8;
final int digitalInfoIdx = 9;

class ParserLibrary {
  Future<Set<Book>> parseBooksFromHtml(http.Response response) async {
    final document = parse(response.body);

    final Set<Book> booksList = Set();

    Logger().i('HTML: ', response.body);
    // get the book section (<tr valign=baseline>)
    document.querySelectorAll('[valign=baseline]').forEach((Element element) {
      final rows = element.querySelectorAll('td');

      final String author = rows.elementAt(authorInfoIdx).text;
      Logger().i('Author: ', author);
      // check this title
      final String titleText = rows.elementAt(titleInfoIdx).text;
      // + 5 in order to remove spaces
      final String title = titleText.substring(titleText.lastIndexOf('>') + 5);
      Logger().i('Title: ', title);

      final String yearText = rows.elementAt(yearInfoIdx).text;
      // remove white space
      final String year = yearText.substring(0, yearText.length - 1);
      Logger().i('year: ', year);

      final String documentType = rows.elementAt(documentTypeIdx).text;
      Logger().i('documentType: ', documentType);

      final String imagePath = rows.elementAt(imagePathIdx).text != null
          ? rows.elementAt(imagePathIdx).text
          : '';
      Logger().i('imagePath: ', imagePath);

      // check the return of this.
      final bool digitalAvailable =
          rows.elementAt(digitalAvailableIdx).text != null ? true : false;
      Logger().i('DigitalAvailable: ', digitalAvailable);

      final String digitalInfo = rows.elementAt(digitalInfoIdx).text != null
          ? element.querySelector('td:nth-child($digitalInfoIdx)').text
          : '';
      Logger().i('DigitalInfo: ', digitalInfo);

      final Book book = Book(author, title, year, imagePath, digitalAvailable,
          digitalInfo, documentType);

      booksList.add(book);
    });

    return booksList;
  }
}
