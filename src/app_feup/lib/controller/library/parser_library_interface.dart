import 'package:uni/model/entities/book.dart';
import 'package:http/http.dart' as http;

abstract class ParserLibraryInterface {
  /**
   * Parses an html and gets books from it
   */
  Future<Set<Book>> parseBooksFeed(http.Response response,
      {String cookie = null});
}
