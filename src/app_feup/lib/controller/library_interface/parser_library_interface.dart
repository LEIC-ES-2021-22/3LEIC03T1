import 'package:uni/model/entities/book.dart';
import 'package:http/http.dart' as http;

abstract class ParserLibraryInterface {
  Future<Set<Book>> parseBooksFromHtml(http.Response response);
}
