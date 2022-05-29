import 'package:uni/model/entities/book.dart';
import 'package:uni/model/entities/book_reservation.dart';
import 'package:uni/model/entities/search_filters.dart';

abstract class LibraryInterface {
  Future<Set<Book>> getLibraryBooks(String url, SearchFilters filters);
  Future<Set<BookReservation>> getReservations();
  Future<int> reserveBook(
      String beginDate, String endDate, String notes, bool isUrgent, Book book);
}
