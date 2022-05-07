import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uni/model/entities/book.dart';
import 'package:uni/model/entities/book_reservation.dart';
import 'package:uni/model/utils/reservation_status.dart';
import 'package:uni/view/Widgets/library_container.dart';

class ReservationContainer extends LibraryContainer {
  final BookReservation reservation;

  ReservationContainer({Key key, @required this.reservation})
      : super(key: key, book: Book.fromReservation(reservation));

  @override
  Widget buildLibraryContainerBody(BuildContext context) {
    return Expanded(
        child: Container(
            margin: EdgeInsets.only(left: 12),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                book.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              SizedBox(height: 10),
              Text(reservation.getDateIndicator(),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .apply(fontSizeDelta: -2)),
              Expanded(
                  child: Container(
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.only(bottom: 5),
                  child: Text(
                    toString(reservation.status),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .apply(color: reservation.getStatusColor()),
                  ),
                ))
            ])));
  }
}
