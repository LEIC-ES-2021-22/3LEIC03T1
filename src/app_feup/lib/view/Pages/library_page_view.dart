import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/book.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/book_container.dart';
import 'package:uni/view/Widgets/library_search_header.dart';

class LibraryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LibraryPageState();
}

final List<Book> mockedBooks = [
  Book(
    title: 'Programming - principles and practice using C++',
    author: 'Stroustrup, Bjarne',
    unitsAvailable: 5,
    totalUnits: 7,
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

class LibraryPageState extends SecondaryPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, Tuple2<List<dynamic>, RequestStatus>>(
      converter: (store) {
        final List<Book> books = store.state.content['searchBooks'];
        return Tuple2(books, store.state.content['searchBooksStatus']);
      },
      builder: (context, searchResults) {
        return LibrarySearch(
          books: searchResults.item1,
          searchBooksStatus: searchResults.item2,
        );
      },
    );
  }
}

class LibrarySearch extends StatelessWidget {
  final List<Book> books;
  final RequestStatus searchBooksStatus;

  LibrarySearch({Key key, @required this.books, this.searchBooksStatus})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Column(
            key: Key('searchFeedColumn'),
            mainAxisSize: MainAxisSize.max,
            children: this.createSearchFeed(context, books),
          ),
        )
      ],
    );
  }

  List<Widget> createSearchFeed(context, books) {
    final List<Widget> columns = <Widget>[];
    columns.add(LibrarySearchHeader());

    switch (searchBooksStatus) {
      case RequestStatus.successful:
        if (books.isEmpty) {
          columns.add(SizedBox(height: 5));
          columns.add(Text('Não foram encontrados resultados',
              maxLines: 2,
              overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.headline4));
          break;
        }

        for (Book book in books) {
          columns.add(BookContainer(book: book));
        }

        break;
      case RequestStatus.busy:
        columns.add(Container(
            padding: EdgeInsets.all(22.0),
            child: Center(child: CircularProgressIndicator())));
        break;
      case RequestStatus.failed:
        columns.add(SizedBox(height: 5));
        columns.add(Text('Não foi possível obter resultados',
            maxLines: 2,
            overflow: TextOverflow.fade,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .apply(color: Colors.red[800])));
        break;
      default:
        break;
    }

    return columns;
  }
}
