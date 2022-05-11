import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
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
      this.book.releaseYear = "desconhecido";
    if (this.book.editor == null)
      this.book.editor = "desconhecido";
    if (this.book.isbnCode == null)
      this.book.isbnCode = "desconhecido";
    if (this.book.language == null)
      this.book.language = "desconhecido";

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
          padding: EdgeInsets.fromLTRB(150, 180, 15, 0),
          child: Row (
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: bookActionButtons(context, this.book),
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

    if (book.unitsAvailable != null) {
      if (book.unitsAvailable == 1) {
        header_info.add(Text(
            '${book.unitsAvailable} unidade disponível',
            style: TextStyle(color: Colors.red[700]),
        ));
      } else if (book.unitsAvailable > 1) {
        header_info.add(Text(
              '${book.unitsAvailable} unidades disponíveis',
              style: TextStyle(color: Colors.black),
          ));
      } else {
        header_info.add(Text(
          'Nenhuma unidade disponível',
          style: TextStyle(color: Colors.red[900]),
        ));
      }
    }
    return header_info;
  }

  bookActionButtons(BuildContext context, Book book) {

    final List<Widget> buttons = <Widget>[];

    if (book.unitsAvailable > 0) {
      buttons.add(
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: Size(90, 45)
            ),
            onPressed: () {
              openBookReservationDialog(context, this.book);
            },
            child: Text("RESERVAR"),
          )
      );
    }

    if (book.hasDigitalVersion) {
      buttons.add(
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(50, 50),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(25.0),
              ),
            ),
            onPressed: () {
              //TODO: Download Action here
            },
            child: Icon(
              Icons.download_sharp,
            ),
          )
      );
    }

    return buttons;

  }

  Future openBookReservationDialog(BuildContext context, Book book) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Book Reservation'),
        content: TextField(
          //controller: dateinput, //editing controller of this TextField
          decoration: InputDecoration(
              icon: Icon(Icons.calendar_today), //icon of text field
              labelText: "Enter Date" //label text of field
          ),
          readOnly: true,  //set it true, so that user will not able to edit text
          onTap: () async {
            DateTime pickedDate = await showDatePicker(
                context: context, initialDate: DateTime.now(),
                firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2101)
            );

            if(pickedDate != null ){
              print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
              print(formattedDate); //formatted date output using intl package =>  2021-03-16
              //you can implement different kind of Date Format here according to your requirement

              /*setState(() {
                dateinput.text = formattedDate; //set output date to TextField value.
              });*/
            }else{
              print("Date is not selected");
            }
          },
        ),
        actions: [
          TextButton(
            child: Text('SUBMIT'),
            onPressed: () {
              //TODO: Book Reservation Logic
              Navigator.of(context).pop();
            },
          )
        ],
      ),
  );
}
