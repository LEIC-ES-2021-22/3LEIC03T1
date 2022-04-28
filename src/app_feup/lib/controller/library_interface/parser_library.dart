import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/library_interface/parser_library_interface.dart';
import 'package:uni/model/entities/book.dart';

//import 'package:web_scraper/web_scraper.dart';

final int authorInfoIdx = 2;
final int titleInfoIdx = 3;
final int yearInfoIdx = 4;
final int documentTypeIdx = 5;
final int imagePathIdx = 7;
final int digitalInfoIdx = 9;

String gBookUrl(String isbn) =>
    'https://media.springernature.com/w153/springer-static/cover/book/$isbn.jpg';

class ParserLibrary implements ParserLibraryInterface {
  @override
  Future<Set<Book>> parseBooksFromHtml(http.Response response) async {
    final document = parse(response.body);

    final Set<Book> booksList = Set();

    // get the book section (<tr valign=baseline>)
    document.querySelectorAll('[valign=baseline]').forEach((Element element) {
      final rows = element.querySelectorAll('td');

      final String author = rows.elementAt(authorInfoIdx).text;

      final String titleText = rows.elementAt(titleInfoIdx).innerHtml;
      final String title = titleText
          .substring(titleText.indexOf('</script>') + '</script>'.length)
          .trim();

      final String year = rows.elementAt(yearInfoIdx).text.trim();

      final String documentType = rows.elementAt(documentTypeIdx).text.trim();

      // TODO get the isbn
      final String imageHtml = rows.elementAt(imagePathIdx).innerHtml != null
          ? rows.elementAt(imagePathIdx).innerHtml
          : '';

      String bookIsbn = imageHtml != ''
          ? imageHtml
              .substring(
                  imageHtml.indexOf('var isbnaleph=') + 'var isbnaleph='.length,
                  imageHtml.indexOf('if (isbnaleph == "<BR>")'))
              .trim()
          : false;

      bookIsbn = bookIsbn.substring(1, bookIsbn.length - 2); // remove " and ;

      bookIsbn = bookIsbn == '<BR>' ? '' : bookIsbn;

      final String digitalInfoHtml =
          // when has url they write url
          rows.elementAt(digitalInfoIdx).text.trim() == 'url'
              ? rows.elementAt(digitalInfoIdx).innerHtml
              : '';

      // check the return of this.
      final bool digitalAvailable = digitalInfoHtml != '' ? true : false;

      final String digitalInfo = digitalInfoHtml != ''
          ? digitalInfoHtml.substring(
              digitalInfoHtml.indexOf('<img src="') + '<img src="'.length,
              digitalInfoHtml.indexOf('border="0" alt=') -
                  2) // remove the quotation marks
          : null;

      final Book book = Book(
          author,
          title,
          year,
          bookIsbn == '' ? '' : gBookUrl(bookIsbn),
          digitalAvailable,
          digitalInfo,
          documentType,
          bookIsbn);

      booksList.add(book);
    });

    return booksList;
  }
}
