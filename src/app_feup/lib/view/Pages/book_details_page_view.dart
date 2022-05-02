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
  themes: ['Programação', 'C++'],
  unitsAvailable: 5,
  hasDigitalVersion: true,
  hasPhysicalVersion: true,
  releaseYear: '2008',
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
    return Stack(
      children: [
        Container(
          height: 200.0,
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
                  Text(
                    "Detalhes do Livro",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 65, 0, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                book.imageURL,
                width: 100,
                height: 150,
                fit: BoxFit.fill,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.0),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(book.author),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                          "${book.unitsAvailable} / ${book.totalUnits} unidades disponíveis"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(180, 180, 0, 0),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  //TODO: Reserve Action here
                },
                child: Text("RESERVAR"),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  //TODO: Download Action here
                },
                child: Icon(
                  Icons.download_sharp,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(30, 260, 0, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: this.createBookThemes(context, book),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Ano: ${book.releaseYear}",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Editor: ${book.editor}",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "ISBN: ${book.isbnCode}",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 120,
              ),
              Icon(
                Icons.language,
                color: Colors.black,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "${book.language}",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> createBookThemes(BuildContext context, Book book) {
    final List<Widget> themes = <Widget>[];

    book.themes = ['Programação', 'C++'];

    themes.add(Text(
      "Temas",
      style: const TextStyle(
        fontSize: 18,
      ),
    ));

    themes.add(SizedBox(
      height: 18,
    ));

    if (book.themes != null) {
      for (int i = 0; i < book.themes.length; ++i) {
        themes.add(
          Text('\u2022  ${book.themes[i]}'),
        );
        themes.add(
          SizedBox(
            height: 8,
          ),
        );
      }
    } else {
      themes.add(Text("Não há temas"));
    }

    return themes;
  }
}
