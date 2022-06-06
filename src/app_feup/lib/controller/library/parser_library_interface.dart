import 'dart:io';

import 'package:uni/model/entities/book.dart';
import 'package:http/http.dart' as http;
import 'package:uni/model/entities/book_reservation.dart';

abstract class ParserLibraryInterface {
  /**
   * Parses an html and gets books from it
   */
  Future<Set<Book>> parseBooksFeed(http.Response response,
      {Cookie alephCookie});

  /**
   * Parses an html and gets reservations from it
   * @param reservationType 0 -> Reservation Request | 1 -> Active Reservation | 2 -> Reservation History 
   */
  Future<Set<BookReservation>> parseReservations(
      http.Response response, String faculty, int reservationType);

  /**
   * Parses an html and gets the reservation error from it
   */
  Future<String> parseReservationError(http.Response response);
}
