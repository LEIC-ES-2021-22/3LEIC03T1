import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/book_reservation.dart';
import 'package:uni/model/utils/reservation_status.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/library_reservations_header.dart';
import 'package:uni/view/Widgets/reservation_container.dart';
import 'package:uni/view/Widgets/book_reservation_details.dart';

class LibraryReservations extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LibraryReservationsState();
}

final List<BookReservation> mockedReservations = [
  BookReservation(
    title: 'Programming - principles and practice using C++ && Java',
    author: 'Stroustrup, Bjarne',
    reservationNumber: 1,
    acquisitionDate: DateTime.now().add(Duration(days: 4)),
    returnDate: DateTime.now().add(Duration(days: 14)),
    pickupLocation: 'FEUP',
    status: ReservationStatus.pending,
    unitsAvailable: 5,
    hasDigitalVersion: true,
    hasPhysicalVersion: true,
    imageURL:
        'https://books.google.com/books/content?id=hxOpAwAAQBAJ&printsec=frontcover&img=1&zoom=5',
  ),
  BookReservation(
    title: 'Modern condensed matter physics',
    author: 'Girvin, Steven M.',
    reservationNumber: 2,
    acquisitionDate: DateTime.now().subtract(Duration(days: 15)),
    returnDate: DateTime.now().subtract(Duration(days: 7)),
    pickupLocation: 'FCUP',
    status: ReservationStatus.delayed,
    unitsAvailable: 3,
    hasDigitalVersion: false,
    hasPhysicalVersion: true,
    imageURL:
        'https://books.google.com/books/content?id=YYKFDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl',
  ),
  BookReservation(
    title: 'Os 4 elementos',
    author: 'Pereira, Paulo',
    reservationNumber: 3,
    acquisitionDate: DateTime.now(),
    returnDate: DateTime.now().add(Duration(days: 7)),
    pickupLocation: 'FMUP',
    status: ReservationStatus.readyForCollection,
    unitsAvailable: 1,
    hasDigitalVersion: true,
    hasPhysicalVersion: false,
    imageURL:
        'https://catalogo.up.pt/exlibris/aleph/a23_1/apache_media/IGPUKB5JD1LIFR6JQLBX5ET2EE91C9D6PXF.jpg',
  )
];

class LibraryReservationsState extends SecondaryPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) {
        // TODO Connect with search
        // CHANGE THIS
        final List<BookReservation> reservations =
            store.state.content['reservations'];
        return reservations;
      },
      builder: (context, reservations) {
        return LibraryReservationsBody(reservations: mockedReservations);
      },
    );
  }
}

class LibraryReservationsBody extends StatelessWidget {
  final List<BookReservation> reservations;

  LibraryReservationsBody({Key key, @required this.reservations})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: this.createReservationsFeed(context, reservations),
          ),
        )
      ]
    );
  }

  List<Widget> createReservationsFeed(context, reservations) {
    final List<Widget> columns = <Widget>[];
    columns.add(LibraryReservationsHeader());

    for (int i = 0; i < reservations.length; ++i) {
      columns.add(ReservationContainer(reservation: reservations[i]));
    }

    return columns;
  }
}
