import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/library_interface/library.dart';
import 'package:uni/controller/library_interface/parser_library_interface.dart';
import 'package:uni/model/entities/book.dart';

final int bookDetailsIdx = 0;
final int authorInfoIdx = 2;
final int titleInfoIdx = 3;
final int yearInfoIdx = 4;
final int documentTypeIdx = 5;
final int unitsIdx = 6;
final int gImgPathIdx = 7;
final int catalogImgPathIdx = 8;
final int digitalInfoIdx = 9;

final int languageIdx = 4;
final int localIdx = 5;
final int editorIdx = 6;
final int themesIdx = 12;

String catalogBookUrl(String book) => 'https://catalogo.up.pt$book';

String gBookUrl(String isbn) =>
    'https://media.springernature.com/w153/springer-static/cover/book/$isbn.jpg';

class ParserLibrary implements ParserLibraryInterface {
  /**
   * Parses the html received in response and gets the details of a book
   * from it
   */
  Future<Map<String, dynamic>> parseBookDetailsHtml(
      http.Response response) async {
    final document = parse(utf8.decode(response.bodyBytes));

    final Map<String, dynamic> bookDetails = {
      'editor': '',
      'language': '',
      'local': '',
      'themes': []
    };

    // get all the information tags
    final List<Element> elements = document.querySelectorAll('[class=td1]');
    int idx = 0;
    while (idx < elements.length) {
      // first <td> has the information name, like language, Editor, year ...
      // Second <td> has its value, the language, year, editor's name ...
      final Element element = elements.elementAt(idx);

      String elemInfo = element.text.trim().toLowerCase();

      String info = elements.elementAt(idx + 1).text.trim();

      if (elemInfo == 'língua') {
        bookDetails['language'] = info;
      } else if (elemInfo == 'local') {
        bookDetails['local'] = info;
      } else if (elemInfo == 'editor') {
        bookDetails['editor'] = info;
      } else if (elemInfo == 'assunto(s)') {
        // it has at least 1 theme
        bookDetails['themes'] = [elements.elementAt(idx + 1).text.trim()];

        // get next theme
        int currIdx = idx + 2;
        elemInfo = elements.elementAt(currIdx).text.trim();

        while (elemInfo == '') {
          info = elements.elementAt(currIdx + 1).text.trim();
          // get the theme and add it to the list
          bookDetails['themes'].add(info);
          currIdx += 2;
          elemInfo = elements.elementAt(currIdx).text.trim();
        }
      }

      idx += 2;
    }
    return bookDetails;
  }

  @override
  Future<Set<Book>> parseBooks(http.Response response,
      {String cookie = null}) async {
    final document = parse(response.body);

    final Set<Book> booksList = Set();

    // get the book section (<tr valign=baseline>)
    final List<Element> elements =
        document.querySelectorAll('[valign=baseline]');

    for (Element element in elements) {
      final rows = element.querySelectorAll('td');

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
                  .firstChild // <img> with src
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

      String bookImageUrl = '';
      if (catalogImage != '') {
        bookImageUrl = catalogBookUrl(catalogImage);
      } else if (bookIsbn != '') {
        bookImageUrl = gBookUrl(bookIsbn);
      }

      final String digitalInfoHtml =
          rows.elementAt(digitalInfoIdx).text.trim() == 'url'
              ? rows.elementAt(digitalInfoIdx).innerHtml
              : '';

      final bool hasDigitalVersion = digitalInfoHtml != '' ? true : false;
      final String digitalURL = hasDigitalVersion
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

      final String bookDetailsHtml = rows.elementAt(bookDetailsIdx).innerHtml;
      final String bookDetailsLink = bookDetailsHtml
          .substring(
              bookDetailsHtml.indexOf('<a HREF=') +
                  '<a HREF='.length +
                  2, // remove = and "
              bookDetailsHtml.indexOf('</a>') -
                  rows.elementAt(bookDetailsIdx).text.length -
                  2)
          .replaceAll('amp;', ''); // remove ; " and &amp;

      final http.Response bdResponse =
          await Library.getHtml(bookDetailsLink, cookie: cookie);
      final Map<String, dynamic> bookDetailsMap =
          await parseBookDetailsHtml(bdResponse);

      final BookDetails bookDetails = BookDetails.fromJson(bookDetailsMap);

      final Book book = Book(
        title: title,
        author: author,
        editor: bookDetails.editor,
        releaseYear: year,
        language: bookDetails.language,
        country: bookDetails.local,
        unitsAvailable: unitsAvailable,
        totalUnits: totalUnits,
        hasPhysicalVersion: totalUnits > 0 ? true : false,
        hasDigitalVersion: hasDigitalVersion,
        digitalURL: digitalURL,
        imageURL: bookImageUrl,
        documentType: documentType,
        isbnCode: bookIsbn,
        themes: bookDetails.themes,
      );

      booksList.add(book);
    }
    return booksList;
  }
}
