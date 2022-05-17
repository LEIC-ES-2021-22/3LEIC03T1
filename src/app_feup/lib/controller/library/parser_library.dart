import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:uni/controller/library/library.dart';
import 'package:uni/controller/library/parser_library_interface.dart';
import 'package:uni/model/entities/book.dart';

final int bookDetailsIdx = 0;
final int authorInfoIdx = 2;
final int titleInfoIdx = 3;
final int yearInfoIdx = 4;
final int documentTypeIdx = 5;
final int unitsIdx = 6;
final int isbnIdx = 7;
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
      'editor': null,
      'language': null,
      'local': null,
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
  Future<Set<Book>> parseBooksFeed(http.Response response) async {
    final document = parse(response.body);

    final Set<Book> booksList = Set();

    // get the book section (<tr valign=baseline>)
    final List<Element> elements =
        document.querySelectorAll('[valign=baseline]');

    for (Element element in elements) {
      final rows = element.querySelectorAll('td[class=td1]');

      final String encodedAuthor = rows.elementAt(authorInfoIdx).text;
      final String author = decodeLibraryText(encodedAuthor);

      final String titleText = rows.elementAt(titleInfoIdx).innerHtml;
      final String rawTitle = titleText
          .substring(titleText.indexOf('</script>') + '</script>'.length)
          .trim();
      final String encodedTitle = parse(rawTitle).documentElement.text;
      final String title = decodeLibraryText(encodedTitle);

      final String year = rows.elementAt(yearInfoIdx).text.trim();

      // TODO Check if other text fields need to be decoded
      final String documentType = rows.elementAt(documentTypeIdx).text.trim();

      // getting the img from catalog
      final String isbnHtml = rows.elementAt(isbnIdx).innerHtml;

      String catalogImage = '';
      final Element catalogImgPath = rows.elementAt(catalogImgPathIdx);
      final int catalogNumChildren = catalogImgPath.children.length;
      if (catalogNumChildren == 1) {
        // Check if is a link or just an image
        if (catalogImgPath.firstChild.hasChildNodes()) {
          catalogImage = catalogImgPath
              .firstChild // <a> with image inside
              .firstChild // <img> with src
              .attributes['src'];
        } else {
          catalogImage = catalogImgPath
              .firstChild // <img> with src
              .attributes['src'];
        }
      }

      String bookIsbn = isbnHtml
          .substring(
              isbnHtml.indexOf('var isbnaleph=') + 'var isbnaleph='.length,
              isbnHtml.indexOf('if (isbnaleph == "<BR>")'))
          .trim();

      bookIsbn = bookIsbn.substring(1, bookIsbn.length - 2); // remove " and ;
      bookIsbn = bookIsbn == '<BR>' ? '' : bookIsbn;

      String bookImageUrl = null;
      if (catalogImage != '') {
        bookImageUrl = catalogBookUrl(catalogImage);
      } else if (bookIsbn != '') {
        bookImageUrl = gBookUrl(bookIsbn);
      }

      final digitalText = rows.elementAt(digitalInfoIdx).text.trim();

      final String digitalInfoHtml =
          digitalText.contains('url') || digitalText.contains('pdf')
              ? rows
                  .elementAt(digitalInfoIdx)
                  .firstChild // <table>
                  .firstChild // <tbody>
                  .firstChild // <tr>
                  .firstChild // <td>
                  .firstChild // <a>
                  .attributes['href']
              : '';

      final bool hasDigitalVersion = digitalInfoHtml != '';
      final String digitalURL = hasDigitalVersion
          ? digitalInfoHtml.substring(
              digitalInfoHtml.indexOf('javascript:open_window') +
                  'javascript:open_window'.length +
                  2, // remove ("
              digitalInfoHtml.length - 3 // remove ");
              )
          : null;

      String units = rows.elementAt(unitsIdx).innerHtml.trim();

      int unitsAvailable = 0;
      int totalUnits = 0;
      if (units != '<br>') {
        // has content so lets get the faculty. If has more than 1, we're getting
        // just the first one
        units = rows.elementAt(unitsIdx).firstChild.text.trim();
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

      final Cookie alephCookie = await Library().parseAlephCookie();
      final http.Response bdResponse =
          await Library.getHtml(bookDetailsLink, cookies: [alephCookie]);

      final Map<String, dynamic> bookDetailsMap =
          await parseBookDetailsHtml(bdResponse);

      final Book book = Book(
        title: title,
        author: author,
        editor: bookDetailsMap['editor'],
        releaseYear: year,
        language: bookDetailsMap['language'],
        country: bookDetailsMap['local'],
        unitsAvailable: unitsAvailable,
        totalUnits: totalUnits,
        hasPhysicalVersion: totalUnits > 0 || unitsAvailable > 0 ? true : false,
        hasDigitalVersion: hasDigitalVersion,
        digitalURL: digitalURL,
        imageURL: bookImageUrl,
        documentType: documentType,
        isbnCode: bookIsbn,
        themes: List<String>.from(bookDetailsMap['themes']),
      );

      booksList.add(book);
    }
    return booksList;
  }

  String decodeLibraryText(String encoded) {
    String decoded = '';
    for (int i = 0; i < encoded.length; i++) {
      try {
        // Try to decode 8-bit char
        final String utf8Decoded = utf8.decode(encoded[i].codeUnits);
        decoded += utf8Decoded;
      } catch (e) {
        try {
          // Try to decode 16-bit char
          final List<int> codeUnits = encoded.substring(i, i + 2).codeUnits;
          final String utf8Decoded = utf8.decode(codeUnits);
          decoded += utf8Decoded;
          ++i;
        } catch (e) {
          // Handle the remaining errors not handled by utf8.decode()
          decoded += String.fromCharCodes(encoded[i].codeUnits);
        }
      }
    }

    return decoded;
  }

  Future<Set<Book>> parseReservations(http.Response response) {
    final Document document = parse(utf8.decode(response.bodyBytes));

    final List<Element> rows = document.querySelectorAll('#centered');
    Logger().i("Number of rows found:", rows.length);

    for (Element row in rows) {
      final parent = row.parent;
      Logger().i("Parent:", parent.innerHtml);
    }
  }
}
