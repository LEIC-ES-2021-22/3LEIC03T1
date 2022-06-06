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
    final borderRadius = BorderRadius.circular(3);

    final grayAreaHeight = vs(210, context);
    final fullWidth = hs(MediaQuery.of(context).size.width, context);
    final btnsHeight = vs(40, context);
    final topContainerHeight = grayAreaHeight + btnsHeight;

    return ListView(
      children: [
        Container(
          height: topContainerHeight,
          width: fullWidth,
          child: Stack(children: [
            Container(
                height: grayAreaHeight,
                width: fullWidth,
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
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                      hs(20, context), vs(10, context), 0, 0),
                  child: Column(
                    key: Key('reservationDetailsCol'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Detalhes da Reserva',
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(height: vs(15, context)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: this.reservation.book.title,
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
                                    offset: Offset(
                                        2, 2), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                  borderRadius: borderRadius,
                                  child: SizedBox.fromSize(
                                      //size: Size.fromRadius(55), // Image radius
                                      child: Image.network(
                                    this.reservation.book.imageURL,
                                    width: hs(90, context),
                                    height: vs(140, context),
                                    fit: BoxFit.fill,
                                  ))),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  hs(15, context),
                                  vs(15, context),
                                  hs(7, context),
                                  vs(0, context)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: this.createReservationHeaderInfo(
                                    context, this.reservation),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            Positioned(
                top: grayAreaHeight - btnsHeight / 2,
                left: fullWidth / 2 + hs(50, context),
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        reservationActionButtons(context, this.reservation),
                  ),
                )),
          ]),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              hs(20, context), vs(0, context), hs(20, context), vs(0, context)),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: vs(15, context),
                      ),
                      Text(
                        'Data de aquisição: \n${this.reservation.getAcquisitionDate()}',
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                      SizedBox(
                        height: vs(30, context),
                      ),
                      Text(
                        'Data de devolução: \n${this.reservation.getReturnDate()}',
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                      SizedBox(
                        height: vs(30, context),
                      ),
                      Text(
                        'Levantamento: \n${pickupLoc}',
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: vs(15, context),
                        ),
                        Text(
                          'Nº Reserva :\n${this.reservation.reservationNumber}',
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        SizedBox(
                          height: vs(30, context),
                        ),
                        if (!this.reservation.showDevolutionTime()) ...[
                          Text(
                            'Devolver em: \n${this.reservation.getRemainingDays()}',
                            style: const TextStyle(fontSize: 16, height: 1.5),
                            overflow: TextOverflow.fade,
                          )
                        ]
                      ]),
                ),
              ]),
        ),
      ],
    );
  }

  createReservationHeaderInfo(
      BuildContext context, BookReservation reservation) {
    final List<Widget> headerInfo = <Widget>[];

    headerInfo.add(Text(
      reservation.book.title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
    ));
    headerInfo.add(SizedBox(height: vs(6, context)));
    headerInfo.add(Text(reservation.book.author));
    headerInfo.add(SizedBox(height: vs(40, context)));
    headerInfo.add(Text(
      '${toString(reservation.status)}',
      style: TextStyle(color: reservation.getStatusColor()),
    ));

    return headerInfo;
  }

  reservationActionButtons(BuildContext context, BookReservation reservation) {
    final List<Widget> buttons = <Widget>[];

    /* if (reservation.book.unitsAvailable != null &&
        reservation.book.unitsAvailable > 0) {
      buttons.add(ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(hs(50, context), vs(40, context))),
        onPressed: () {
          //TODO: GoToReservationPage but with information from the current reservation
        },
        child: Text('RENOVAR'),
      ));
    } */

    if (/* reservation.book.hasDigitalVersion */ true) {
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
