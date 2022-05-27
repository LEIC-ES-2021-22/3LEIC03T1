import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/book.dart';
import 'package:uni/model/entities/book_reservation.dart';
import 'package:uni/model/utils/reservation_status.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/library_reservations_header.dart';
import 'package:uni/view/Widgets/reservation_container.dart';

class LibraryReservations extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LibraryReservationsState();
}

final List<BookReservation> mockedReservations = [
  BookReservation(
    reservationNumber: 1,
    acquisitionDate: DateTime.now().add(Duration(days: 4)),
    returnDate: DateTime.now().add(Duration(days: 14)),
    pickupLocation: 'FEUP',
    status: ReservationStatus.pending,
    book: Book(
      title: 'Programming - principles and practice using C++',
      author: 'Stroustrup, Bjarne',
      unitsAvailable: 5,
      hasDigitalVersion: true,
      hasPhysicalVersion: true,
      imageURL:
          'https://books.google.com/books/content?id=hxOpAwAAQBAJ&printsec=frontcover&img=1&zoom=5',
    ),
  ),
  BookReservation(
    reservationNumber: 2,
    acquisitionDate: DateTime.now().subtract(Duration(days: 15)),
    returnDate: DateTime.now().subtract(Duration(days: 7)),
    pickupLocation: 'FCUP',
    status: ReservationStatus.delayed,
    book: Book(
      title: 'Modern condensed matter physics',
      author: 'Girvin, Steven M.',
      unitsAvailable: 3,
      hasDigitalVersion: false,
      hasPhysicalVersion: true,
      imageURL:
          'https://books.google.com/books/content?id=YYKFDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl',
    ),
  ),
  BookReservation(
    reservationNumber: 3,
    acquisitionDate: DateTime.now(),
    returnDate: DateTime.now().add(Duration(days: 7)),
    pickupLocation: 'FMUP',
    status: ReservationStatus.readyForCollection,
    book: Book(
      title: 'Os 4 elementos',
      author: 'Pereira, Paulo',
      unitsAvailable: 1,
      hasDigitalVersion: true,
      hasPhysicalVersion: false,
      imageURL:
          'https://catalogo.up.pt/exlibris/aleph/a23_1/apache_media/IGPUKB5JD1LIFR6JQLBX5ET2EE91C9D6PXF.jpg',
    ),
  )
];

class LibraryReservationsState extends SecondaryPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, Tuple2<List<dynamic>, RequestStatus>>(
      converter: (store) {
        final List<BookReservation> reservations =
            store.state.content['catalogReservations'];
        return Tuple2(
            reservations, store.state.content['catalogReservationsStatus']);
      },
      builder: (context, reservationsInfo) {
        return LibraryReservationsBody(
          reservations: reservationsInfo.item1,
          reservationsStatus: reservationsInfo.item2,
        );
      },
    );
  }
}

class LibraryReservationsBody extends StatelessWidget {
  final List<BookReservation> reservations;
  final RequestStatus reservationsStatus;

  LibraryReservationsBody(
      {Key key, @required this.reservations, this.reservationsStatus})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Container(
        child: Column(
          key: Key('reservationsFeedColumn'),
          mainAxisSize: MainAxisSize.max,
          children: this.createReservationsFeed(context, reservations),
        ),
      )
    ]);
  }

  List<Widget> createReservationsFeed(context, reservations) {
    final List<Widget> columns = <Widget>[];
    columns.add(LibraryReservationsHeader());

    switch (reservationsStatus) {
      case RequestStatus.successful:
        for (int i = 0; i < reservations.length; ++i) {
          columns.add(ReservationContainer(reservation: reservations[i]));
        }
        break;
      case RequestStatus.busy:
        columns.add(Container(
            padding: EdgeInsets.all(22.0),
            child: Center(child: CircularProgressIndicator())));
        break;
      case RequestStatus.failed:
        columns.add(SizedBox(height: 5));
        columns.add(Text('Não foi possível obter as reservas',
            maxLines: 2,
            overflow: TextOverflow.fade,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .apply(color: Colors.red[800])));
        break;
      default:
        break;
    }

    return columns;
  }
}
