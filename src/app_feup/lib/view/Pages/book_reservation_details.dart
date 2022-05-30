import 'package:flutter/material.dart';
import 'package:uni/utils/methods.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni/model/entities/book_reservation.dart';
import 'package:uni/model/utils/reservation_status.dart';
import 'package:flutter/widgets.dart';

class ReservationDetails extends StatefulWidget {
  ReservationDetails({Key key, @required this.reservation}) : super(key: key);
  final BookReservation reservation;

  @override
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
  ReservationDetailsWidget({Key key, @required this.reservation})
      : super(key: key);
  final BookReservation reservation;

  @override
  Widget build(BuildContext context) {
    final String pickupLoc = '${this.reservation.pickupLocation}'.toUpperCase();
    return Stack(
      children: [
        Container(
          height: vs(220, context),
          width: hs(MediaQuery.of(context).size.width, context),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3),
                  topRight: Radius.circular(3),
                  bottomLeft: Radius.circular(7),
                  bottomRight: Radius.circular(7)),
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
            padding: EdgeInsets.fromLTRB(hs(15, context), vs(20, context),
                hs(0, context), vs(0, context)),
            child: Text(
              'Detalhes da Reserva',
              overflow: TextOverflow.fade,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(hs(20, context), vs(80, context),
              hs(0, context), vs(30, context)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: this.reservation.book.title,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 4,
                        blurRadius: 2,
                        offset: Offset(2,2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Image.network(
                    this.reservation.book.imageURL,
                    width: hs(80, context),
                    height: vs(145, context),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(hs(7, context), vs(10, context),
                      hs(7, context), vs(0, context)),
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
          padding: EdgeInsets.fromLTRB(hs(150, context), vs(105, context),
              hs(15, context), vs(0, context)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: reservationActionButtons(context, this.reservation),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(hs(10, context), vs(260, context),
              hs(60, context), vs(0, context)),
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
                    height: vs(15, context),
                  ),
                  Text(
                    'Data de aquisição: \n${this.reservation.getAcquisitionDate()}',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(
                    height: vs(15, context),
                  ),
                  Text(
                    'Data de devolução: \n${this.reservation.getReturnDate()}',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(
                    height: vs(15, context),
                  ),
                  Text(
                    'Local de Levantamento: \n${pickupLoc}',
                    style: const TextStyle(
                      fontSize: 12,
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
                            width: hs(10, context),
                            height: vs(15, context),
                          ),
                          Text(
                            'Nº Reserva :\n${this.reservation.reservationNumber}',
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            height: vs(15, context),
                          ),
                          Text(
                            'Devolução: \n${this.reservation.getDateIndicator()}',
                            style: const TextStyle(
                              fontSize: 12,
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
    final List<Widget> headerInfo = <Widget>[];

    headerInfo.add(Text(
      reservation.book.title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
    ));
    headerInfo.add(SizedBox(height: vs(10, context)));
    headerInfo.add(Text(reservation.book.author));
    headerInfo.add(SizedBox(height: vs(20, context)));
    headerInfo.add(Text(
      '${toString(reservation.status)}',
      style: TextStyle(color: reservation.getStatusColor()),
    ));

    return headerInfo;
  }

  reservationActionButtons(BuildContext context, BookReservation reservation) {
    final List<Widget> buttons = <Widget>[];

    if (reservation.book.unitsAvailable != null &&
        reservation.book.unitsAvailable > 0) {
      buttons.add(ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(hs(50, context), vs(40, context))),
        onPressed: () {
          //TODO: GoToReservationPage but with information from the current reservation
        },
        child: Text('RENOVAR'),
      ));
    }

    if (reservation.book.hasDigitalVersion) {
      buttons.add(ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(hs(50, context), vs(40, context)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onPressed: () async {
          final url = reservation.book.digitalURL;
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
}
