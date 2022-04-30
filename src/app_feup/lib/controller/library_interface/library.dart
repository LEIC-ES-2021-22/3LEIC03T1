import 'dart:async';

import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/library_interface/library_interface.dart';
import 'package:uni/controller/library_interface/parser_library.dart';
import 'package:uni/controller/library_interface/parser_library_interface.dart';
import 'package:uni/model/entities/book.dart';
import 'package:http/http.dart' as http;

extension UriString on String {
  /// Converts a [String] to an [Uri].
  Uri toUri() => Uri.parse(this);
}

final String testUrl =
    'https://catalogo.up.pt/F/?func=find-b&request=Design+Patterns';

final String baseUrl = 'https://catalogo.up.pt/F';

// TODO found out that find_code=WRD means "search for words" and find_code=WAU
// its "search for author" sometimes the default changes to WAU or other one
// and we can't search think about placing it in the query $query&find_code=WRD
String baseSearchUrl(String query) =>
    'https://catalogo.up.pt/F/?func=find-b&request=$query&find_code=WRD';

class Library implements LibraryInterface {
  // TODO after get cookie from login receive it on this function and use it
  @override
  Future<Set<Book>> getLibraryBooks(String query) async {
    final ParserLibraryInterface parserLibrary = ParserLibrary();

    // cookie just works if we get it from the base URL for some reason.
    final Response cookieResponse = await getHtml(baseUrl);

    final String cookie = await parseCookie(cookieResponse);

    final Response response =
        await getHtml(baseSearchUrl(query), cookie: cookie);

    final Set<Book> libraryBooks =
        await parserLibrary.parseBooksFromHtml(response);

    return libraryBooks;
  }

  Future<http.Response> getHtml(String url, {String cookie = null}) async {
    final Map<String, String> headers = Map<String, String>();
    if (cookie != null) headers['cookie'] = cookie;

    final http.Response response =
        await http.get(url.toUri(), headers: headers);

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 403) {
      // HTTP403 - Forbidden;
      Logger().e('Library Books request failed');
      return Future.error('Library Books request failed');
    } else {
      return Future.error('HTTP Error ${response.statusCode}');
    }
  }

  Future<String> parseCookie(Response response) async {
    final document = parse(response.body);
    final element = document.querySelector('[language="Javascript"]');
    final String cookie = element.text
        .substring(element.text.indexOf('=') + 3, element.text.indexOf(';'));

    return cookie;
  }
}
