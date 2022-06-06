import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uni/controller/library/library_utils.dart';
import 'package:uni/model/entities/book.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:uni/view/Widgets/book_reservation_dialog.dart';
import 'package:uni/view/Widgets/library_details_header.dart';
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
    return ListView(
      children: [
        LibraryDetailsHeader(
          key: Key('bookDetailsHeader'),
          headerTitle: 'Detalhes do Livro',
          heroTag: this.book.title,
          bookUrl: this.book.imageURL,
          headerInfo: this.createBookHeaderInfo(context, this.book),
          btnWidgets: bookActionButtons(context, this.book),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(hs(20, context), vs(0, context),
                hs(20, context), vs(0, context)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: this.createBookDetails(context, this.book)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            this.createBookDetailsRight(context, this.book)),
                  )
                ])),
      ],
    );
  }

  List<Widget> createBookThemes(BuildContext context, Book book) {
    final List<Widget> themes = <Widget>[];
    themes.add(Text(
      'Temas:',
      style: const TextStyle(fontSize: 20, height: 1),
    ));

    themes.add(SizedBox(
      height: vs(5, context),
    ));

    if (book.themes != null && book.themes.isNotEmpty) {
      for (int i = 0; i < book.themes.length; ++i) {
        themes.add(
          Text(
            '\t\t \u2022  ${book.themes[i]}',
            style: const TextStyle(fontSize: 16),
          ),
        );
        themes.add(
          SizedBox(height: vs(7, context)),
        );
      }
    } else {
      themes.add(Text('Não existem temas disponíveis',
          style: const TextStyle(
            fontSize: 16,
          )));
    }

    return themes;
  }

  createBookHeaderInfo(BuildContext context, Book book) {
    final List<Widget> headerInfo = <Widget>[];

    headerInfo.add(
      Container(
        height: vs(40, context),
        child: Text(
          book.title,
          overflow: TextOverflow.clip,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
          maxLines: 2,
        ),
      ),
    );
    headerInfo.add(
      Container(
        height: vs(40, context),
        child: Text(
          book.author,
          overflow: TextOverflow.clip,
          style: const TextStyle(fontSize: 13.0),
          maxLines: 2,
        ),
      ),
    );
    //headerInfo.add(SizedBox(height: vs(15, context)));

    headerInfo.add(SizedBox(height: vs(15, context)));

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

    final bool hasUnitsAvailable =
        book.unitsAvailable != null && book.unitsAvailable <= 0;
    if (hasUnitsAvailable) {
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
      buttons.add(Container(
        margin: EdgeInsets.fromLTRB(
            hasUnitsAvailable ? hs(15, context) : hs(60, context), 0, 0, 0),
        child: ElevatedButton(
          key: Key('downloadButton'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(35, 35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          onPressed: () async {
            await launch(this.book.digitalURL);
          },
          child: Icon(
            Icons.download_sharp,
          ),
        ),
      ));
    }
    return buttons;
  }

  List<Widget> createBookDetailsRight(BuildContext context, Book book) {
    final List<Widget> bookDetailsRight = <Widget>[];

    if (this.book.language != null && this.book.language.isNotEmpty) {
      String language;
      if (initToLang.containsKey(this.book.language)) {
        language = initToLang[this.book.language];
      } else {
        language = 'Português';
      }

      bookDetailsRight.add(Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.language,
            color: Colors.black,
            size: 25,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(7, 0, 0, 0),
            child: Text(
              language,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          )
        ],
      ));

      bookDetailsRight.add(SizedBox(
        height: vs(20, context),
      ));
    }

    if (this.book.releaseYear != null && this.book.releaseYear.isNotEmpty) {
      bookDetailsRight.add(
        Text(
          'Ano: ${this.book.releaseYear}',
          style: const TextStyle(fontSize: 18, height: 1.5),
        ),
      );
    }

    return bookDetailsRight;
  }

  List<Widget> createBookDetails(BuildContext context, Book book) {
    final List<Widget> bookDetails = <Widget>[];

    bookDetails.add(Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: this.createBookThemes(context, this.book),
    ));

    bookDetails.add(SizedBox(
      height: vs(20, context),
    ));

    if (this.book.editor != null && this.book.editor.isNotEmpty) {
      bookDetails.add(
        Text(
          'Editor:',
          style: const TextStyle(fontSize: 18, height: 1.5),
        ),
      );
      bookDetails.add(
        Text(
          this.book.editor,
          style: const TextStyle(fontSize: 16),
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
          'ISBN:',
          style: const TextStyle(fontSize: 18, height: 1.5),
        ),
      );
      bookDetails.add(Text(
        this.book.isbnCode,
        style: const TextStyle(
          fontSize: 16,
        ),
      ));
    }

    return bookDetails;
  }

  Future openBookReservationDialog(BuildContext context, Book book) =>
      showDialog(
          context: context,
          builder: (context) => BookReservationDialog(book: this.book));
}
