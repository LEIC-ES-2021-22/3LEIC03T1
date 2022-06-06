import 'package:flutter/material.dart';
import 'package:uni/utils/methods.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:uni/view/Widgets/library_details_header.dart';
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

    return ListView(
      children: [
        LibraryDetailsHeader(
          key: Key('bookReservationDetailsHeader'),
          headerTitle: 'Detalhes da Reserva',
          heroTag: this.reservation.book.title,
          bookUrl: this.reservation.book.imageURL == null
              ? 'assets/images/book_placeholder.png'
              : this.reservation.book.imageURL,
          headerInfo:
              this.createReservationHeaderInfo(context, this.reservation),
          btnWidgets: reservationActionButtons(context, this.reservation),
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

    headerInfo.add(Container(
      height: vs(40, context),
      child: Text(
        reservation.book.title,
        overflow: TextOverflow.clip,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
        maxLines: 2,
      ),
    ));

    headerInfo.add(Container(
      height: vs(30, context),
      child: Text(
        reservation.book.author,
        overflow: TextOverflow.clip,
        style: const TextStyle(fontSize: 14.0),
        maxLines: 2,
      ),
    ));

    headerInfo.add(SizedBox(height: vs(20, context)));
    headerInfo.add(Text(
      '${toString(reservation.status)}',
      style: TextStyle(color: reservation.getStatusColor()),
    ));

    return headerInfo;
  }

  reservationActionButtons(BuildContext context, BookReservation reservation) {
    final List<Widget> buttons = <Widget>[];

    if (reservation.book.hasDigitalVersion) {
      buttons.add(Container(
        margin: EdgeInsets.fromLTRB(hs(60, context), 0, 0, 0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(hs(50, context), vs(45, context)),
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
        ),
      ));
    }

    return buttons;
  }
}
