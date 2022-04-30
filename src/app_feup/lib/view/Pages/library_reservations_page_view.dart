import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/book.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/book_container.dart';
import 'package:uni/view/Widgets/library_reservations_header.dart';
import 'package:uni/view/Widgets/library_search_header.dart';

class LibraryReservations extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LibraryReservationsState();
}

final List<Book> mockedBooks = [
  Book(
    title: 'Programming - principles and practice using C++',
    author: 'Stroustrup, Bjarne',
    unitsAvailable: 5,
    hasDigitalVersion: true,
    hasPhysicalVersion: true,
    imageURL:
        'https://books.google.com/books/content?id=hxOpAwAAQBAJ&printsec=frontcover&img=1&zoom=5',
  ),
  Book(
    title: 'Modern condensed matter physics',
    author: 'Girvin, Steven M.',
    unitsAvailable: 3,
    hasDigitalVersion: false,
    hasPhysicalVersion: true,
    imageURL:
        'https://books.google.com/books/content?id=YYKFDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl',
  ),
  Book(
    title: 'Os 4 elementos',
    author: 'Pereira, Paulo',
    unitsAvailable: 1,
    hasDigitalVersion: true,
    hasPhysicalVersion: false,
    imageURL:
        'https://catalogo.up.pt/exlibris/aleph/a23_1/apache_media/IGPUKB5JD1LIFR6JQLBX5ET2EE91C9D6PXF.jpg',
  )
];

class LibraryReservationsState extends SecondaryPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) {
        // TODO Connect with search
        // CHANGE THIS
        final List<Book> books = store.state.content['searchBooks'];
        return books;
      },
      builder: (context, books) {
        return LibraryReservationsBody(books: mockedBooks);
      },
    );
  }
}

class LibraryReservationsBody extends StatelessWidget {
  final List<Book> books;

  LibraryReservationsBody({Key key, @required this.books}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: this.createReservationsFeed(context, books),
          ),
        )
      ],
    );
  }

  List<Widget> createReservationsFeed(context, reservations) {
    final List<Widget> columns = <Widget>[];
    columns.add(LibraryReservationsHeader());

    /* for (int i = 0; i < reservations.length; ++i) {
      columns.add(BookContainer(
          book: reservations[i], type: BookContainerType.searchResult));
    } */

    return columns;
  }
}
