import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/library_interface/parser_library_interface.dart';
import 'package:uni/model/entities/book.dart';

//import 'package:web_scraper/web_scraper.dart';

final int bookDetailsIdx = 0;
final int authorInfoIdx = 2;
final int titleInfoIdx = 3;
final int yearInfoIdx = 4;
final int documentTypeIdx = 5;
final int unitsIdx = 6;
final int gImgPathIdx = 7;
final int catalogImgPathIdx = 8;
final int digitalInfoIdx = 9;

String catalogBookUrl(String book) => 'https://catalogo.up.pt$book';

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

      final String bookDetailsHtml = rows.elementAt(bookDetailsIdx).innerHtml;
      // TODO check this link and then get the information of the book
      // by scrapping the page
      final String bookDetailsLink = bookDetailsHtml.substring(
          bookDetailsHtml.indexOf('<a HREF=') +
              '<a HREF='.length +
              2, // remove = and "
          bookDetailsHtml.indexOf('</a>') -
              rows.elementAt(bookDetailsIdx).text.length -
              2); // remove ; and "

      final String author = rows.elementAt(authorInfoIdx).text;

      final String titleText = rows.elementAt(titleInfoIdx).innerHtml;
      final String title = titleText
          .substring(titleText.indexOf('</script>') + '</script>'.length)
          .trim();

      final String year = rows.elementAt(yearInfoIdx).text.trim();

      final String documentType = rows.elementAt(documentTypeIdx).text.trim();

      // getting the img from catalog
      final String imageHtml = rows.elementAt(gImgPathIdx) != null
          ? rows.elementAt(gImgPathIdx).innerHtml
          : '';

      final String catalogImage =
          rows.elementAt(catalogImgPathIdx).children.isNotEmpty
              ? rows
                  .elementAt(catalogImgPathIdx)
                  .firstChild // <a> with image inside
                  .firstChild // <img with src
                  .attributes['src']
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
          rows.elementAt(digitalInfoIdx).text.trim() == 'url'
              ? rows.elementAt(digitalInfoIdx).innerHtml
              : '';

      final bool hasDigitalVersion = digitalInfoHtml != '' ? true : false;

      final String digitalURL = digitalInfoHtml != ''
          ? digitalInfoHtml.substring(
              digitalInfoHtml.indexOf('<img src="') + '<img src="'.length,
              digitalInfoHtml.indexOf('border="0" alt=') -
                  2) // remove the quotation marks
          : null;

      String units = rows.elementAt(unitsIdx).text.trim();
      int unitsAvailable = 0;
      int totalUnits = 0;
      if (units != '') {
        units = units.substring(units.indexOf('(') + '('.length);
        totalUnits = int.parse(units.substring(0, units.indexOf('/')));
        unitsAvailable = int.parse(
            units.substring(units.indexOf('/') + 1, units.length - 1));
      }

      String bookImageUrl = '';

      if (catalogImage != '') {
        bookImageUrl = catalogBookUrl(catalogImage);
      } else if (bookIsbn != '') {
        bookImageUrl = gBookUrl(bookIsbn);
      }

      // TODO editor, language, country, themes
      final Book book = Book(
        title: title,
        author: author,
        releaseYear: year,
        unitsAvailable: unitsAvailable,
        totalUnits: totalUnits,
        hasPhysicalVersion: unitsAvailable > 0 ? true : false,
        hasDigitalVersion: hasDigitalVersion,
        digitalURL: digitalURL,
        imageURL: bookImageUrl,
        documentType: documentType,
        isbnCode: bookIsbn,
      );

      booksList.add(book);
    });

    return booksList;
  }
}
