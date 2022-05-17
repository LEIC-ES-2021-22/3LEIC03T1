import 'package:uni/model/entities/book.dart';
import 'package:http/http.dart' as http;
import 'package:uni/model/entities/book_reservation.dart';

abstract class ParserLibraryInterface {
  /**
   * Parses an html and gets books from it
   */
  Future<Set<Book>> parseBooksFeed(http.Response response);

  /**
   * Parses an html and gets reservations from it
   */
  Future<Set<BookReservation>> parseReservations(
      http.Response response, String faculty);
}
