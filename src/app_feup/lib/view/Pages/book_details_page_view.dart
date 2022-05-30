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
    final borderRadius = BorderRadius.circular(3);
    return Stack(
      children: [
        Container(
          height: vs(230.0, context),
          width: hs(MediaQuery.of(context).size.width, context),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: Offset(hs(4, context),
                      vs(3, context)), // changes position of shadow
                ),
              ]),
          child: Padding(
            padding: EdgeInsets.fromLTRB(hs(15, context), vs(25, context),
                hs(0, context), vs(0, context)),
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
          padding: EdgeInsets.fromLTRB(
              hs(20, context), vs(82, context), hs(0, context), vs(0, context)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                  tag: book.title,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 4,
                            blurRadius: 2,
                            offset: Offset(2, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ClipRRect(
                          borderRadius: borderRadius,
                          child: SizedBox.fromSize(
                            //size: Size.fromRadius(55), // Image radius
                            child: Image.network(
                              this.book.imageURL == null
                                  ? 'assets/images/book_placeholder.png'
                                  : this.book.imageURL,
                              width: hs(100, context),
                              height: vs(154, context),
                              fit: BoxFit.fill,
                            ),
                          )))),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(hs(15, context), vs(0, context),
                      hs(15, context), vs(0, context)),
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
          padding: EdgeInsets.fromLTRB(hs(150, context), vs(180, context),
              hs(15, context), vs(0, context)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: bookActionButtons(context, this.book),
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(hs(30, context), vs(260, context),
                hs(30, context), vs(0, context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: this.createBookDetails(context, this.book),
            )),
      ],
    );
  }

  List<Widget> createBookThemes(BuildContext context, Book book) {
    final List<Widget> themes = <Widget>[];
    themes.add(SizedBox(
      height: vs(20, context),
    ));
    themes.add(Text(
      'Temas',
      style: const TextStyle(
        fontSize: 14,
      ),
    ));

    themes.add(SizedBox(
      height: vs(20, context),
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
      themes.add(Text('Não existem temas disponíveis',
          style: const TextStyle(
            fontSize: 14,
          )));
    }

    return themes;
  }

  createBookHeaderInfo(BuildContext context, Book book) {
    final List<Widget> headerInfo = <Widget>[];

    headerInfo.add(
      Container(
        height: vs(80, context),
        child: Text(
          book.title,
          overflow: TextOverflow.fade,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
        ),
      ),
    );
    headerInfo.add(SizedBox(height: vs(10, context)));
    headerInfo.add(
      Container(
        height: vs(30, context),
        child: Text(
          book.author,
          overflow: TextOverflow.fade,
        ),
      ),
    );
    headerInfo.add(SizedBox(height: vs(12, context)));

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
    } else {
      headerInfo.add(Text(
        'Disponibilidade desconhecida',
        style: TextStyle(color: Colors.black),
      ));
    }
    return headerInfo;
  }

  bookActionButtons(BuildContext context, Book book) {
    final List<Widget> buttons = <Widget>[];

    if (book.unitsAvailable != null && book.unitsAvailable <= 0) {
      buttons.add(ElevatedButton(
        key: Key('reserveBook'),
        style: ElevatedButton.styleFrom(minimumSize: Size(90, 45)),
        onPressed: () {
          openBookReservationDialog(context, book);
        },
        child: Text('RESERVAR'),
      ));
    }

    if (book.hasDigitalVersion) {
      buttons.add(ElevatedButton(
        key: Key('downloadButton'),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(50, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onPressed: () async {
          await launch(book.digitalURL);
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
      //headerInfo.add(SizedBox(height: vs(8, context)));
      bookDetailsRight.add(SizedBox(width: hs(20, context)));
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
            fontSize: 12,
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
                fontSize: 12,
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
            fontSize: 12,
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
            fontSize: 12,
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
            fontSize: 12,
          ),
        ),
      );
    }

    return bookDetails;
  }

  Future openBookReservationDialog(BuildContext context, Book book) =>
      showDialog(
          context: context,
          builder: (context) => BookReservationDialog(book: this.book));
}
