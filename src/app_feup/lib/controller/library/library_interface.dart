import 'dart:io';

import 'package:uni/model/entities/book.dart';
import 'package:uni/model/entities/book_reservation.dart';
import 'package:uni/model/entities/search_filters.dart';

abstract class LibraryInterface {
  Future<Set<Book>> getLibraryBooks(
      String url, SearchFilters filters, Cookie alephCookie);
  Future<Set<BookReservation>> getReservations();
}
