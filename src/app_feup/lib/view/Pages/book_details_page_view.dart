import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/book.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';

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

    if (this.book.releaseYear == null)
      this.book.releaseYear = "unknown";
    if (this.book.editor == null)
      this.book.editor = "unknown";
    if (this.book.isbnCode == null)
      this.book.isbnCode = "unknown";
    if (this.book.language == null)
      this.book.language = "unknown";

    return Stack(
      children: [
        Container(
          height: 200.0,
          width: MediaQuery.of(context).size.width,
          color: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 17, 0, 0),
            child: Text(
              "Detalhes do Livro",
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
                  tag: this.book.title,
                  child: Image.network(
                    this.book.imageURL,
                    width: 100,
                    height: 150,
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
          padding: EdgeInsets.fromLTRB(30, 260, 30, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: this.createBookThemes(context, this.book),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Text(
                    "Ano: ${this.book.releaseYear}",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Editor: ${this.book.editor}",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "ISBN: ${this.book.isbnCode}",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.language,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${this.book.language}",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> createBookThemes(BuildContext context, Book book) {
    final List<Widget> themes = <Widget>[];

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

  createBookHeaderInfo(BuildContext context, Book book) {
    final List<Widget> header_info = <Widget>[];

    header_info.add(
        Text(
          book.title,
          style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 17.0),
    )
    );
    header_info.add(SizedBox(height: 10));
    header_info.add(Text(book.author));
    header_info.add(SizedBox(height: 15));

    if (book.unitsAvailable != null && book.totalUnits != null) {
      if (book.unitsAvailable == 1)
        header_info.add(Text("${book.unitsAvailable} / ${book.totalUnits} unidade disponível"));
      else if (book.unitsAvailable > 1)
          header_info.add(Text("${book.unitsAvailable} / ${book.totalUnits} unidades disponíveis"));
      else
        header_info.add(Text("Nenhuma unidade disponível"));
    }


    return header_info;
  }
}
