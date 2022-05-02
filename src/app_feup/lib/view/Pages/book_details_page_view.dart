import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/book.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';

class BookDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BookDetailsState();
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

class BookDetailsState extends SecondaryPageViewState {
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
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      color: Colors.black12,
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.black,

                  ),
                ),
              ),
              Text(book.title)
            ],
          )
        ],
      ),
    );
  }
}
