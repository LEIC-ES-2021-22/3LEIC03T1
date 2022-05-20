import 'dart:async';

import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/library/library_interface.dart';
import 'package:uni/controller/library/parser_library.dart';
import 'package:uni/controller/library/parser_library_interface.dart';
import 'package:uni/model/entities/book.dart';
import 'package:http/http.dart' as http;
import 'package:uni/model/entities/search_filters.dart';

extension UriString on String {
  /// Converts a [String] to an [Uri].
  Uri toUri() => Uri.parse(this);
}

final String baseUrl = 'https://catalogo.up.pt/F';

String baseSearchUrl(String query, SearchFilters filters) {
  String url =
      'https://catalogo.up.pt/F/?func=find-b&request=$query&find_code=WRD';

  if (filters.languageQuery != null && filters.languageQuery != '') {
    url += '&filter_code_1=WLN&filter_request_1=' + filters.languageQuery;
  }

  if (filters.countryQuery != null && filters.countryQuery != '') {
    url += '&filter_code_2=WCN&filter_request_2=' + filters.countryQuery;
  }

  if (filters.yearQuery != null && filters.yearQuery != '') {
    url += '&filter_code_3=WYR&filter_request_3=' + filters.yearQuery;
  }

  if (filters.docTypeQuery != null && filters.docTypeQuery != '') {
    url += '&filter_code_5=WFMT&filter_request_5=' + filters.docTypeQuery;
  }

  return url;
}

class Library implements LibraryInterface {
  // TODO after get cookie from login receive it on this function and use it
  @override
  Future<Set<Book>> getLibraryBooks(String query, SearchFilters filters) async {
    final ParserLibraryInterface parserLibrary = ParserLibrary();

    // cookie only works if we get it from the base URL
    final Response cookieResponse = await getHtml(baseUrl);

    final String cookie = await parseCookie(cookieResponse);

    final Response response =
        await Library.getHtml(baseSearchUrl(query, filters), cookie: cookie);

    final Set<Book> libraryBooks =
        await parserLibrary.parseBooksFeed(response, cookie: cookie);

    return libraryBooks;
  }

  static Future<http.Response> getHtml(String url,
      {String cookie = null}) async {
    final Map<String, String> headers = Map<String, String>();
    if (cookie != null) headers['cookie'] = cookie;

    final http.Response response =
        await http.get(url.toUri(), headers: headers);

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 403) {
      // HTTP403 - Forbidden;
      Logger().e('Library Books request failed. Request was forbidden');
      return Future.error(
          'Library Books request failed. Request was forbidden');
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
