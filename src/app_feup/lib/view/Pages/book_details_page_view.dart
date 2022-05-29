import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uni/model/entities/book.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:uni/view/Widgets/book_reservation_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni/utils/methods.dart';

class BookDetails extends StatefulWidget {
  BookDetails({Key key, @required this.book}) : super(key: key);
  final Book book;

  @override
  State<StatefulWidget> createState() => BookDetailsState(book: book);
}

class BookDetailsState extends UnnamedPageView {
  BookDetailsState({@required this.book});
  final Book book;

  @override
  Widget getBody(BuildContext context) {
    return BookDetailsWidget(book: this.book);
  }
}

class BookDetailsWidget extends StatelessWidget {
  BookDetailsWidget({Key key, @required this.book}) : super(key: key);
  final Book book;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: vs(200.0, context),
          width: MediaQuery.of(context).size.width,
          color: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 17, 0, 0),
            child: Text(
              'Detalhes do Livro',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 65, 0, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: book.title,
                child: Image.network(
                  this.book.imageURL == null
                      ? 'assets/images/book_placeholder.png'
                      : this.book.imageURL,
                  width: hs(100, context),
                  height: vs(150, context),
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: this.createBookHeaderInfo(context, this.book),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(150, 180, 15, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: bookActionButtons(context, this.book),
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(30, 260, 30, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: this.createBookDetails(context, this.book),
            )),
      ],
    );
  }

  List<Widget> createBookThemes(BuildContext context, Book book) {
    final List<Widget> themes = <Widget>[];

    themes.add(Text(
      'Temas',
      style: const TextStyle(
        fontSize: 18,
      ),
    ));

    themes.add(SizedBox(
      height: vs(18, context),
    ));

    if (book.themes != null && book.themes.isNotEmpty) {
      for (int i = 0; i < book.themes.length; ++i) {
        themes.add(
          Text('\u2022  ${book.themes[i]}'),
        );
        themes.add(
          SizedBox(height: vs(8, context)),
        );
      }
    } else {
      themes.add(Text('Não existem temas disponíveis'));
    }

    return themes;
  }

  createBookHeaderInfo(BuildContext context, Book book) {
    final List<Widget> headerInfo = <Widget>[];

    headerInfo.add(
      Container(
        height: 80,
        child: Text(
          book.title,
          overflow: TextOverflow.fade,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
        ),
      ),
    );
    headerInfo.add(SizedBox(height: vs(8, context)));
    headerInfo.add(
      Container(
        height: 30,
        child: Text(
          book.author,
          overflow: TextOverflow.fade,
        ),
      ),
    );
    headerInfo.add(SizedBox(height: vs(10, context)));

    var totalUnits = '';
    if (book.totalUnits != null) {
      totalUnits = '/ ${book.totalUnits}';
    }

    if (book.unitsAvailable != null) {
      if (book.unitsAvailable == 1) {
        headerInfo.add(Text(
          '${book.unitsAvailable} ${totalUnits} unidade disponível',
          style: TextStyle(color: Colors.red[700]),
        ));
      } else if (book.unitsAvailable > 1) {
        headerInfo.add(Text(
          '${book.unitsAvailable} ${totalUnits} unidades disponíveis',
          style: TextStyle(color: Colors.black),
        ));
      } else {
        headerInfo.add(Text(
          'Nenhuma unidade disponível',
          style: TextStyle(color: Colors.red[900]),
        ));
      }
    }
    return headerInfo;
  }

  bookActionButtons(BuildContext context, Book book) {
    final List<Widget> buttons = <Widget>[];

    if (book.unitsAvailable <= 0) {
      buttons.add(
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: Size(90, 45)
            ),
            onPressed: () {
              openBookReservationDialog(context, book);
            },
            child: Text('RESERVAR'),
          )
      );
    }

    if (book.hasDigitalVersion) {
      buttons.add(ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(50, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onPressed: () async {
          const url = 'https://flutter.io';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
        child: Icon(
          Icons.download_sharp,
        ),
      ));
    }

    return buttons;
  }

  List<Widget> createBookDetailsRight(BuildContext context, Book book) {
    final List<Widget> bookDetailsRight = <Widget>[];

    if (this.book.language != null && this.book.language.isNotEmpty) {
      bookDetailsRight.add(
        Icon(
          Icons.language,
          color: Colors.black,
        ),
      );

      bookDetailsRight.add(
        SizedBox(
          width: hs(10, context),
        ),
      );

      bookDetailsRight.add(
        Text(
          '${this.book.language}',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      );
    }

    return bookDetailsRight;
  }

  List<Widget> createBookDetails(BuildContext context, Book book) {
    final List<Widget> bookDetails = <Widget>[];

    bookDetails.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: this.createBookThemes(context, this.book),
    ));

    bookDetails.add(SizedBox(
      height: vs(45, context),
    ));

    if (this.book.language != null && this.book.language.isNotEmpty) {
      bookDetails.add(
        Row(
          children: [
            Icon(
              Icons.language,
              color: Colors.black,
            ),
            SizedBox(
              width: hs(10, context),
            ),
            Text(
              '${this.book.language}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      );

      bookDetails.add(
        SizedBox(
          height: vs(20, context),
        ),
      );
    }

    if (this.book.releaseYear != null && this.book.releaseYear.isNotEmpty) {
      bookDetails.add(
        Text(
          'Ano: ${this.book.releaseYear}',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      );

      bookDetails.add(
        SizedBox(
          height: vs(20, context),
        ),
      );
    }

    if (this.book.editor != null && this.book.editor.isNotEmpty) {
      bookDetails.add(
        Text(
          'Editor: ${this.book.editor}',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      );

      bookDetails.add(
        SizedBox(
          height: vs(20, context),
        ),
      );
    }

    if (this.book.isbnCode != null && this.book.isbnCode.isNotEmpty) {
      bookDetails.add(
        Text(
          'ISBN: ${this.book.isbnCode}',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      );
    }

    return bookDetails;
  }

  Future openBookReservationDialog(BuildContext context, Book book) => showDialog(
      context: context,
      builder: (context) => BookReservationDialog(book: this.book)
  );
}
