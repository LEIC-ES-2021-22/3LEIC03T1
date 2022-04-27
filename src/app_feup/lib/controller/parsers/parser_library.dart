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

      final String titleText = rows.elementAt(titleInfoIdx).innerHtml;
      final String title = titleText
          .substring(titleText.indexOf('</script>') + '</script>'.length)
          .trim();
      Logger().i('Title: ', title);

      final String year = rows.elementAt(yearInfoIdx).text.trim();
      Logger().i('year: ', year);

      final String documentType = rows.elementAt(documentTypeIdx).text.trim();
      Logger().i('documentType: ', documentType);

      /*
      final String imagePath = rows.elementAt(imagePathIdx).text != null
          ? rows.elementAt(imagePathIdx).text
          : '';
      Logger().i('imagePath: ', imagePath);
      */

      // check the return of this.
      final bool digitalAvailable =
          rows.elementAt(digitalAvailableIdx).text != null ? true : false;
      Logger().i('DigitalAvailable: ', digitalAvailable);

      final String digitalInfoHtml =
          // when has url they write url
          rows.elementAt(digitalInfoIdx).text.trim() == 'url'
              ? rows.elementAt(digitalInfoIdx).innerHtml
              : '';
      final String digitalInfo = digitalInfoHtml != ''
          ? digitalInfoHtml.substring(
              digitalInfoHtml.indexOf('<img src="') + '<img src="'.length,
              digitalInfoHtml.indexOf('border="0" alt=') -
                  2) // remove the quotation marks
          : null;
      Logger().i('DigitalInfo: ', digitalInfo);

      final Book book = Book(author, title, year, '' /*TO DO imagePath*/,
          digitalAvailable, digitalInfo, documentType);

      booksList.add(book);
    });

    return booksList;
  }
}
