import 'dart:async';
import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;
import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/library/library_interface.dart';
import 'package:uni/controller/library/parser_library.dart';
import 'package:uni/controller/library/parser_library_interface.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/entities/book.dart';
import 'package:http/http.dart' as http;
import 'package:uni/model/entities/search_filters.dart';

import 'package:cookie_jar/cookie_jar.dart';

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

    catalogLogin();

    // cookie just works if we get it from the base URL for some reason.
    final http.Response cookieResponse = await getHtml(baseUrl);

    final String cookie = await parseCookie(cookieResponse);

    final http.Response response =
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

  Future<String> parseCookie(http.Response response) async {
    final document = html.parse(response.body);
    final element = document.querySelector('[language="Javascript"]');
    final String cookie = element.text
        .substring(element.text.indexOf('=') + 3, element.text.indexOf(';'));

    return cookie;
  }

  /*static Future<void> catalogLogin() async {
    final Tuple2<String, String> userPersistentInfo =
        await AppSharedPreferences.getPersistentUserInfo();
    Logger().i('Inside network catalog login ');
    final String url =
        'https://catalogo.up.pt:/shib/EUP50/pds_main?func=load-login&calling_system=aleph&institute=EUP50&PDS_HANDLE=&url=https://catalogo.up.pt:443/F/?func=BOR-INFO"%3B>%3BEngenharia';

    // Start searching for the right url
    // Code from https://api.flutter.dev/flutter/dart-io/HttpClientRequest/followRedirects.html
    final client = HttpClient();
    var uri = Uri.parse(url);
    var request = await client.getUrl(uri);
    request.followRedirects = false;
    var response = await request.close();
    String location = '';

    while (response.isRedirect) {
      response.drain();
      location = response.headers.value(HttpHeaders.locationHeader);
      //Logger().i(location);
      if (location != null) {
        uri = uri.resolve(location);
        request = await client.getUrl(uri);
        // Set the body or headers as desired.
        // could try to simplify this by parsing the body here
        //
        request.followRedirects = false;
        response = await request.close();
        //Logger().i(response.statusCode);
      }
    }
    // Trying a different way to send a post request
    // Took from https://api.flutter.dev/flutter/dart-io/HttpClientRequest/followRedirects.html
    String finalUrl = 'https://wayf.up.pt' + location;
    final req = Request('POST', Uri.parse(finalUrl))
      ..headers.addAll({'Content-Type': 'application/x-www-form-urlencoded'})
      // ignore: lines_longer_than_80_chars
      ..bodyFields = {
        'username': userPersistentInfo.item1 + '@fe.up.pt',
        'password': userPersistentInfo.item2
      };

    final res = await req.send();
    print(req.headers);
    print(res.statusCode);
    print(res.headers);
    // ignore: avoid_print
    print('Exiting getting final url ' + finalUrl);
    print('user: ' + userPersistentInfo.item1);

    // I dont really know if it's logged, because the body that is returned is the same as the Moodle login.
    // Therefore i dont know if this is working. Besides the Status Code being 200
    final http.Response res2 = await http.post(finalUrl.toUri(), body: {
      'username': userPersistentInfo.item1 + '@feu.up.pt',
      'password': userPersistentInfo.item2
    }).timeout(const Duration(seconds: loginRequestTimeout));
    Logger().i('URL: ', finalUrl);
    Logger().i('Status code :', res2.statusCode);
  }*/

  final cookieRegex = RegExp(r'(?<=^|\S,).*?(?=$|,\S)');
  final _client = http.Client();
  final cookies = CookieJar();

  String _username;
  String _password;

  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final sentCookies = await cookies.loadForRequest(request.url);
    Logger().i("Cookies sent", sentCookies);

    if (sentCookies.isNotEmpty) {
      final cookieHeader =
          sentCookies.map((e) => '${e.name}=${e.value}').join('; ');

      request.headers['cookie'] = cookieHeader;
    }

    final response = await _client.send(request);

    final receivedCookies = response.headers['set-cookie'];
    if (receivedCookies != null) {
      final parsedCookies = cookieRegex
          .allMatches(receivedCookies)
          .map((e) => e.group(0))
          .where((element) => element != null)
          .cast<String>()
          .map((e) => Cookie.fromSetCookieValue(e))
          .toList();

      await cookies.saveFromResponse(request.url, parsedCookies);
    }

    return response;
  }

  Future<List<http.Response>> _getUrlWithRedirects(Uri url) async {
    final responses = List<http.Response>.empty(growable: true);

    var request = http.Request('GET', url);
    request.followRedirects = false;

    var response = await http.Response.fromStream(await send(request));
    responses.add(response);

    var currentUrl = url;
    while (response.isRedirect) {
      final location = response.headers['location'];

      if (location != null) {
        currentUrl = currentUrl.resolve(location);

        request = http.Request('GET', currentUrl);
        request.followRedirects = false;

        response = await http.Response.fromStream(await send(request));
        responses.add(response);
      }
    }

    return responses;
  }

  Future<void> catalogLogin() async {
    final String link =
        'https://catalogo.up.pt/shib/EUP50/pds_main?func=load-login&calling_system=aleph&institute=EUP50&PDS_HANDLE=&url=https://catalogo.up.pt:443/F/?func=BOR-INFO/';

    final Tuple2<String, String> userPersistentInfo =
        await AppSharedPreferences.getPersistentUserInfo();

    _username = userPersistentInfo.item1 + '@fe.up.pt';
    _password = userPersistentInfo.item2;

    final url = Uri.parse(link);
    final responses = await _getUrlWithRedirects(url);

    Logger().i('Cookies:', await cookies.loadForRequest(url));

    if (responses.length <= 1) {
      // For federated authentication to be sucessful,
      // there needs to be at least a redirect, at the start, from the
      // Service Provider (eg. Moodle) to the Identity Provider
      // (eg. Shibboleth aka AAI)
      throw ArgumentError(
          'The provided url is not a valid authentication endpoint');
    }

    var lastResponse = responses.last;
    var lastResponseLocation = lastResponse.request.url;

    if (lastResponseLocation.host == url.host) {
      // There was an immediate redirect by Shibboleth and,
      // as such, authentication is completed and successful
      if (lastResponse.statusCode != 200) {
        throw StateError('An unknown error occured during the login process');
      }

      return;
    }

    var document = html.parse(lastResponse.body);
    var title = document.querySelector('head > title')?.text;

    // if the title is exactly this, its because appeared to
    // click continue button
    if (title == 'Web Login Service - Loading Session Information') {
      final finalResponse =
          await this.getContinueRequest(document, lastResponseLocation);

      Logger().i(
          'Cookies cont:', await cookies.loadForRequest(lastResponseLocation));

      document = html.parse(finalResponse.body);
      title = document.querySelector('head > title')?.text;
    }

    if (title == 'Web Login Service') {
      final authFields = {
        'username': _username,
        'password': _password,
        'btnLogin': '',
      };

      final formElement = document.querySelector('form');

      final formAction = formElement.attributes['action'];
      final formMethod = formElement.attributes['method'];

      final Map<String, String> formData = {};
      for (var entry in authFields.entries) {
        final element = formElement.querySelector('#${entry.key}');
        final name = element.attributes['name'];

        formData[name] = entry.value;
      }
      formData['csrf_token'] = formElement
          .querySelector('input[name=\"csrf_token\"]')
          .attributes['value'];

      final loginRequest =
          http.Request(formMethod, lastResponseLocation.resolve(formAction));

      loginRequest.bodyFields = formData;

      var loginResponse =
          await http.Response.fromStream(await send(loginRequest));

      lastResponse = loginResponse;
      lastResponseLocation = loginRequest.url;

      final sentCookies = await cookies.loadForRequest(lastResponseLocation);
      Logger().i('Cookie Jar: ', sentCookies);

      // Because there is a very high change we are submitting a POST request,
      // we need to handle the possibility that the client can (and does) send
      // a 302 status code with a redirect. By default, the user agent must
      // specify its behaviour in those situations.
      //
      // See: https://github.com/dart-lang/http/issues/157#issuecomment-417639249
      if (loginResponse.statusCode == 302) {
        final location = loginResponse.headers['location'];
        final loginResponses =
            await _getUrlWithRedirects(loginRequest.url.resolve(location));

        final sentCookies =
            await cookies.loadForRequest(loginRequest.url.resolve(location));
        Logger().i('Cookies redirect: ', sentCookies);

        lastResponse = loginResponse = loginResponses.last;
        lastResponseLocation = lastResponse.request.url;
      }

      document = html.parse(lastResponse.body);
      Logger().i("Document after login -> ", lastResponse.body);
      // TODO IS failling here
      var finalResponse =
          await this.getContinueRequest(document, lastResponseLocation);

      Logger().i('Cookies Continue: ',
          await cookies.loadForRequest(lastResponseLocation));

      Logger().i("Last Continue response", finalResponse.body);

      // PART MISSING TO DO
      lastResponse = finalResponse;

      if (finalResponse.statusCode == 302) {
        final location = finalResponse.headers['location'];
        finalResponse =
            (await _getUrlWithRedirects(lastResponseLocation.resolve(location)))
                .last;

        Logger().i(
            'Cookies redirect 2: ',
            await cookies
                .loadForRequest(lastResponseLocation.resolve(location)));
      }

      if (finalResponse.statusCode != 200) {
        throw StateError('Something went wrong');
      }

      document = html.parse(finalResponse.body);

      var afterLoginLocation = document.querySelector('body > noscript').text;
      afterLoginLocation = afterLoginLocation.substring(
          afterLoginLocation.indexOf('<a href="') + '<a href="'.length,
          afterLoginLocation.indexOf('">Click here to continue'));

      Logger().i("AfterLoginLocation", afterLoginLocation);

      Logger()
          .i("FIUDHAIUFHASFA", "https://catalogo.up.pt" + afterLoginLocation);

      finalResponse = (await _getUrlWithRedirects(
              Uri.parse("https://catalogo.up.pt" + afterLoginLocation)))
          .last;
      Logger().i("finalResponse afterLoginLocation", finalResponse.body);
    } else if (title == 'Information Release') {
      throw StateError('An information release was requested');
    }
  }

  /**
   * Performs the continue action when wayf redirects us to 
   * "no Javascript allowed so click continue button" by getting the
   * form hidden fields and performing the form action
   * @returns the response to the form action 
   */
  Future<http.Response> getContinueRequest(
      Document document, Uri locationUrl) async {
    final formElement = document.querySelector('form');

    final formAction = formElement.attributes['action'];
    final formMethod = formElement.attributes['method'];

    final formElements = formElement.querySelectorAll('input[type=\"hidden\"]');
    final Map<String, String> formData = {};
    for (var element in formElements) {
      final name = element.attributes['name'];
      final value = element.attributes['value'];

      formData[name] = value ?? '';
    }

    final finalRequest =
        http.Request(formMethod, locationUrl.resolve(formAction));

    finalRequest.bodyFields = formData;
    // TODO failling in line 386, see why

    var finalResponse =
        await http.Response.fromStream(await send(finalRequest));
    if (finalResponse.statusCode == 302) {
      final location = finalResponse.headers['location'];
      finalResponse =
          (await _getUrlWithRedirects(finalRequest.url.resolve(location))).last;
    }

    if (finalResponse.statusCode != 200) {
      throw StateError('Something went wrong');
    }

    return finalResponse;
  }
}
