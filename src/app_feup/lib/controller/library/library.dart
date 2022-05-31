import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;
import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/library/library_interface.dart';
import 'package:uni/controller/library/library_utils.dart';
import 'package:uni/controller/library/parser_library.dart';
import 'package:uni/controller/library/parser_library_interface.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/book.dart';
import 'package:http/http.dart' as http;
import 'package:uni/model/entities/search_filters.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:uni/model/entities/book_reservation.dart';

import 'package:redux/redux.dart';
import 'package:uni/redux/actions.dart';

extension UriString on String {
  /// Converts a [String] to an [Uri].
  Uri toUri() => Uri.parse(this);
}

class Library implements LibraryInterface {
  Store<AppState> store;
  final _client = http.Client();
  final cookies = CookieJar();
  Cookie pdsCookie;
  String _username;
  String _password;
  String faculty;

  /**
   * Need to create a factory function since we need the constructor
   *  to have an async method
   */
  static Future<Library> create(
      {Cookie pdsCookie, Store<AppState> store}) async {
    final library = Library();
    if (pdsCookie != null) {
      library.pdsCookie = pdsCookie; // Set libraries' pds cookie if exists
    }

    if (store != null) library.store = store;

    try {
      library.faculty = (await AppSharedPreferences.getUserFaculties()).first;
    } catch (err) {
      Logger().e("Unable to retrieve the user's institution");
    }

    return library;
  }

  /**
   * Wrapper to send a request, after first getting the aleph cookie
   * pdsCookie is an optional argument
   */
  static Future<http.Response> libRequestWithAleph(String url,
      {Cookie pdsCookie}) async {
    final Cookie alephCookie = await parseAlephCookie();

    final List<Cookie> cookies = [alephCookie];
    if (pdsCookie != null) cookies.add(pdsCookie);
    return await getHtml(url, cookies: cookies);
  }

  /**
   * Wrapper to send a request
   * pdsCookie and alephCookies are an optional argument
   */
  Future<http.Response> libRequest(String url,
      {Cookie pdsCookie, Cookie alephCookie}) async {
    final List<Cookie> cookies = [];
    if (pdsCookie != null) cookies.add(pdsCookie);
    if (alephCookie != null) cookies.add(alephCookie);

    http.Response htmlResponse = await getHtml(url, cookies: cookies);

    if (hasSSOerror(htmlResponse)) {
      // Update alephCookie and reset base faculty for that cookie
      alephCookie = await parseAlephCookie();
      this.store.dispatch(SaveCatalogAlephCookie(alephCookie));

      final List<Cookie> newCookies = [alephCookie];
      if (pdsCookie != null) newCookies.add(pdsCookie);

      await getHtml(getFacultyBaseUrl(faculty), cookies: newCookies);

      // Update cookies to send in request
      for (Cookie cookie in cookies) {
        if (cookie.name == 'ALEPH_SESSION_ID') {
          cookie.value = alephCookie.value;
          break;
        }
      }

      htmlResponse = await getHtml(url, cookies: cookies);
    }

    return htmlResponse;
  }

  /**
   * Checks if html has PDS SSO error
   */
  bool hasSSOerror(http.Response response) {
    final document = html.parse(utf8.decode(response.bodyBytes));

    final title = document.querySelector('head > title')?.text?.trim();

    return title == 'PDS SSO';
  }

  @override
  Future<Set<Book>> getLibraryBooks(String query, SearchFilters filters) async {
    final ParserLibraryInterface parserLibrary = ParserLibrary();
    final Cookie alephCookie = this.store.state.content['catalogAlephCookie'];
    final String url = query != '' ? baseSearchUrl(query, filters) : newsUrl();

    final http.Response response =
        await libRequest(url, alephCookie: alephCookie);

    final Set<Book> libraryBooks =
        await parserLibrary.parseBooksFeed(response, alephCookie: alephCookie);

    return libraryBooks;
  }

  // TODO Change this libRequestWithAleph to use libRequest
  // and receive aleph cookie by argument
  @override
  Future<Set<BookReservation>> getReservations() async {
    final reservationRequestResponse = await libRequestWithAleph(
        reservationRequestUrl(this.faculty, this.pdsCookie.value));

    final Set<BookReservation> reservationRequests = await ParserLibrary()
        .parseReservations(reservationRequestResponse, this.faculty, 0);

    final reservationHistoryRes = await libRequestWithAleph(
        reservationHistoryUrl(this.faculty, this.pdsCookie.value));

    final Set<BookReservation> reservationHistory = await ParserLibrary()
        .parseReservations(reservationHistoryRes, this.faculty, 2,
            pdsCookie: this.pdsCookie);

    final activeReservationsRes = await libRequestWithAleph(
        reservationUrl(this.faculty, this.pdsCookie.value));

    final Set<BookReservation> activeReservations = await ParserLibrary()
        .parseReservations(activeReservationsRes, this.faculty, 1,
            pdsCookie: this.pdsCookie);

    final Set<BookReservation> reservations = Set();
    reservations.addAll(reservationRequests);

    reservations.addAll(reservationHistory);
    reservations.addAll(activeReservations);

    return reservations;
  }

  /**
   * Performs the Login on catalog platform, using the username and password
   * of the user in the UNI app. Returns the pds_handle cookie to be stored
  */
  Future<Cookie> catalogLogin() async {
    final Tuple2<String, String> userPersistentInfo =
        await AppSharedPreferences.getPersistentUserInfo();

    final String emailPrefix = facInitials[this.faculty];
    _username = userPersistentInfo.item1 + '@$emailPrefix.up.pt';
    _password = userPersistentInfo.item2;

    _username = buildUp(_username);

    final String link = loginUrl(this.faculty);
    final url = Uri.parse(link);
    final responses = await _getUrlWithRedirects(url);

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

      return null;
    }

    var document = html.parse(lastResponse.body);
    var title = document.querySelector('head > title')?.text;

    // if the title is exactly this, its because appeared to
    // click continue button
    if (title == 'Web Login Service - Loading Session Information') {
      final finalResponse =
          await this.getContinueRequest(document, lastResponseLocation);
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

        await cookies.loadForRequest(loginRequest.url.resolve(location));

        lastResponse = loginResponse = loginResponses.last;
        lastResponseLocation = lastResponse.request.url;
      }

      document = html.parse(lastResponse.body);

      // After the login request, appears the continue button again
      var finalResponse =
          await this.getContinueRequest(document, lastResponseLocation);

      lastResponse = finalResponse;

      if (finalResponse.statusCode == 302) {
        final location = finalResponse.headers['location'];
        finalResponse =
            (await _getUrlWithRedirects(lastResponseLocation.resolve(location)))
                .last;
      }

      if (finalResponse.statusCode != 200) {
        throw StateError('Something went wrong');
      }
      document = html.parse(finalResponse.body);

      var afterLoginLocation = document.querySelector('body > noscript').text;
      afterLoginLocation = afterLoginLocation.substring(
          afterLoginLocation.indexOf('<a href="') + '<a href="'.length,
          afterLoginLocation.indexOf('">Click here to continue'));

      finalResponse = (await _getUrlWithRedirects(
              Uri.parse('https://catalogo.up.pt' + afterLoginLocation)))
          .last;

      // get the pds handle cookie
      final sentCookies = await cookies.loadForRequest(lastResponseLocation);
      this.pdsCookie = sentCookies.elementAt(sentCookies.length - 1);
    } else if (title == 'Information Release') {
      throw StateError('An information release was requested');
    }

    return this.pdsCookie;
  }

  /**
   * Gets the profile html and updates the aleph cookie
   */
  // TODO change this libRequestWithAleph to libRequest and receive aleph
  // cookie By argument
  Future<http.Response> getProfileHtml(Cookie pdsCookie) async {
    final profileLink =
        'https://catalogo.up.pt/F/?func=bor-info&pds_handle=${pdsCookie.value}';

    return await libRequestWithAleph(profileLink);
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

  // Gets the Html of a get Request to Url with or without cookies
  static Future<http.Response> getHtml(String url,
      {List<Cookie> cookies = null}) async {
    final Map<String, String> headers = Map<String, String>();
    if (cookies != null) {
      headers['cookie'] = '';

      for (Cookie cookie in cookies) {
        headers['cookie'] += cookie.name + '=' + cookie.value + ';';
      }
    }

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

  /**
   * Gets the aleph cookie by making a request to baseUrl 
   */
  static Future<Cookie> parseAlephCookie() async {
    final http.Response response = await getHtml(baseUrl);

    final document = html.parse(response.body);
    final element = document.querySelector('[language="Javascript"]');

    // [cookieName, cookieValue]
    final List<String> fullCookie = element.text
        .substring(element.text.indexOf('=') + 3, element.text.indexOf(';'))
        .split(' = ');

    final Cookie cookie = Cookie(fullCookie[0], fullCookie[1]);

    return cookie;
  }

  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final sentCookies = await cookies.loadForRequest(request.url);

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
}
