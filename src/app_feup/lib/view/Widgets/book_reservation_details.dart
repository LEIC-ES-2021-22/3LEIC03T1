import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:logger/logger.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/book.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni/model/entities/book_reservation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:logger/logger.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/book.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ReservationDetails extends StatefulWidget {
  ReservationDetails({Key key, @required this.reservation}) : super(key: key);
  final BookReservation reservation;

  @override
  // ignore: lines_longer_than_80_chars
  State<StatefulWidget> createState() =>
      ReservationDetailsState(reservation: reservation);
}

class ReservationDetailsState extends UnnamedPageView {
  ReservationDetailsState({@required this.reservation});
  final BookReservation reservation;

  @override
  Widget getBody(BuildContext context) {
    return ReservationDetailsWidget(reservation: this.reservation);
  }
}

class ReservationDetailsWidget extends StatelessWidget {
  // ignore: lines_longer_than_80_chars
  ReservationDetailsWidget({Key key, @required this.reservation})
      : super(key: key);
  final BookReservation reservation;

  @override
  Widget build(BuildContext context) {
    /*if (this.reservation.releaseYear == null)
      this.reservation.releaseYear = "desconhecido";
    if (this.reservation.editor == null)
      this.reservation.editor = "desconhecido";
    if (this.reservation.isbnCode == null)
      this.reservation.isbnCode = "desconhecido";
    if (this.reservation.language == null)
      this.reservation.language = "desconhecido";*/

    return Stack(
      children: [
        Container(
          height: 200.0,
          width: MediaQuery.of(context).size.width,
          color: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 17, 0, 0),
            child: Text(
              "Detalhes da Reserva",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 30,
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
                tag: this.reservation.title,
                child: Image.network(
                  this.reservation.imageURL,
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
                    children: this
                        .createReservationHeaderInfo(context, this.reservation),
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
            children: reservationActionButtons(context, this.reservation),
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
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Text(
                    "Data de aquisição: \n${this.reservation.getAcquisitionDate()}",
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Data de devolução: \n${this.reservation.getReturnDate()}",
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Local de Levantamento: \n${this.reservation.pickupLocation}",
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start),
                          SizedBox(
                            height: 40,
                            width: 15,
                          ),
                          Text(
                            "Nº Reserva \n${this.reservation.reservationNumber}",
                            style: const TextStyle(
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Devolução: \n${this.reservation.getDateIndicator()}",
                            style: const TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ]),
                  ]),
            ],
          ),
        ),
      ],
    );
  }

  createReservationHeaderInfo(
      BuildContext context, BookReservation reservation) {
    final List<Widget> header_info = <Widget>[];

    header_info.add(Text(
      reservation.title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
    ));
    header_info.add(SizedBox(height: 10));
    header_info.add(Text(reservation.author));
    header_info.add(SizedBox(height: 15));

    var totalUnits = '';
    if (reservation.totalUnits != null) {
      totalUnits = '/ ${reservation.totalUnits}';
    }

    if (reservation.unitsAvailable != null) {
      if (reservation.unitsAvailable == 1) {
        header_info.add(Text(
          '${reservation.unitsAvailable} ${totalUnits} unidade disponível',
          style: TextStyle(color: Colors.red[700]),
        ));
      } else if (reservation.unitsAvailable > 1) {
        header_info.add(Text(
          '${reservation.status}',
          style: TextStyle(color: reservation.getStatusColor()),
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

  reservationActionButtons(BuildContext context, BookReservation reservation) {
    final List<Widget> buttons = <Widget>[];

    if (reservation.unitsAvailable > 0) {
      buttons.add(ElevatedButton(
        style: ElevatedButton.styleFrom(minimumSize: Size(100, 50)),
        onPressed: () {
          //TODO: Reserve Action here
        },
        child: Text("RENOVAR"),
      ));
    }

    if (reservation.hasDigitalVersion) {
      buttons.add(ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(55, 55),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(25.0),
          ),
        ),
        onPressed: () async {
          const url = "https://flutter.io";
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw "Could not launch $url";
          }
        },
        child: Icon(
          Icons.download_sharp,
        ),
      ));
    }

    return buttons;
  }
}
