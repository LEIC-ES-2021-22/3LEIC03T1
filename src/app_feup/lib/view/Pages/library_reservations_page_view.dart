import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/book_reservation.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/library_reservations_header.dart';
import 'package:uni/view/Widgets/reservation_container.dart';

class LibraryReservations extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LibraryReservationsState();
}

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
        if (reservations.isEmpty) {
          columns.add(SizedBox(height: 5));
          columns.add(Text('Não foram encontradas reservas',
              maxLines: 2,
              overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.headline4));
          break;
        }

        reservations.forEach((reservation) {
          columns.add(ReservationContainer(reservation: reservation));
        });

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
