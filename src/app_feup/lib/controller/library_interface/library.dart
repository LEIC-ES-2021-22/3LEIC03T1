import 'dart:async';
import 'dart:io';

import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
import '../local_storage/app_shared_preferences.dart';
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
String baseSearchUrl(String query) =>
    'https://catalogo.up.pt/F/?func=find-b&request=$query';

class Library implements LibraryInterface {
  // TODO delete after testing
  static const int loginRequestTimeout = 20;
  // TODO after get cookie from login receive it on this function and use it
  @override
  Future<Set<Book>> getLibraryBooks(String query) async {
    final ParserLibraryInterface parserLibrary = ParserLibrary();

    catalogLogin();

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

  static Future<void> catalogLogin() async {
    final Tuple2<String, String> userPersistentInfo =
        await AppSharedPreferences.getPersistentUserInfo();
    Logger().i('Inside network catalog login ');
    final String url = 'https://catalogo.up.pt:/shib/EUP50/pds_main?func=load-login&calling_system=aleph&institute=EUP50&PDS_HANDLE=&url=https://catalogo.up.pt:443/F/?func=BOR-INFO"%3B>%3BEngenharia';
    final client = HttpClient();
    var uri = Uri.parse(url);
    var request = await client.getUrl(uri);
    //Logger().i(request.followRedirects);
    request.followRedirects = false;
    var response = await request.close();
    //Logger().i(response.statusCode);
    String location = '';
    while (response.statusCode != 200) {
      response.drain();
      location = response.headers.value(HttpHeaders.locationHeader);
      //Logger().i(location);
      if (location != null) {
        uri = uri.resolve(location);
        request = await client.getUrl(uri);
        // Set the body or headers as desired.
        request.followRedirects = false;
        response = await request.close();
        //Logger().i(response.statusCode);
      }
    }
    String finalUrl = 'https://wayf.up.pt'+location;
    // ignore: avoid_print
    print('Exiting getting final url '+ finalUrl);
    print('user: ' +userPersistentInfo.item1);
    final http.Response res = await http.post(finalUrl.toUri(), body: {
      'j_username': userPersistentInfo.item1+'@fe.up.pt',
      'j_password': userPersistentInfo.item2
    }).timeout(const Duration(seconds: loginRequestTimeout));
    Logger().i('Body of post', res.body);
    Logger().i('Status code :' ,res.statusCode);
  }


}
