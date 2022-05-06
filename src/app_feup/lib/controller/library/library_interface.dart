import 'package:uni/model/entities/book.dart';

abstract class LibraryInterface {
  Future<Set<Book>> getLibraryBooks(String url);
}
