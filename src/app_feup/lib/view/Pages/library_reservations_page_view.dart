import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/book.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/book_container.dart';
import 'package:uni/view/Widgets/library_search_header.dart';

class LibraryReservations extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LibraryReservationsState();
}

final Book mockedBook = Book(
  title: 'Programming - principles and practice using C++',
  author: 'Stroustrup, Bjarne',
  unitsAvailable: 5,
  hasDigitalVersion: true,
  hasPhysicalVersion: true,
  imageURL:
      'https://books.google.com/books/content?id=hxOpAwAAQBAJ&printsec=frontcover&img=1&zoom=5',
);

class LibraryReservationsState extends SecondaryPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, Book>(
      converter: (store) {
        // TODO Connect with search
        // CHANGE THIS
        final Book book = store.state.content['searchBooks'];
        return book;
      },
      builder: (context, book) {
        return LibrarySearch(book: mockedBook);
      },
    );
  }
}

class LibrarySearch extends StatelessWidget {
  final Book book;

  LibrarySearch({Key key, @required this.book}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(child: Text(book.title));
  }
}
