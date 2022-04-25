import 'package:flutter/widgets.dart';
import 'package:uni/model/entities/book.dart';

enum BookRowType { searchResult, reservation }

class BookRow extends StatelessWidget {
  final Book book;
  final BookRowType type;

  BookRow({Key key, @required this.book, @required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(book.imageURL);
  }
}
