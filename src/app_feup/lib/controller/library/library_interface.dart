import 'package:uni/model/entities/book.dart';
import 'package:uni/model/entities/search_filters.dart';

abstract class LibraryInterface {
  Future<Set<Book>> getLibraryBooks(String url, SearchFilters filters);
}
