import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uni/model/entities/book.dart';
import 'package:uni/utils/methods.dart';
import 'package:uni/model/entities/book_reservation.dart';
import 'package:uni/model/utils/reservation_status.dart';
import 'package:uni/view/Widgets/generic_library_container.dart';
import 'package:uni/view/Widgets/row_container.dart';
import 'package:uni/view/Widgets/book_reservation_details.dart';

class ReservationContainer extends GenericLibraryContainer {
  final BookReservation reservation;

  ReservationContainer({Key key, @required this.reservation})
      : super(key: key, book: Book.fromReservation(reservation));

    @override
  Widget build(BuildContext context) {
    final keyValue = '${book.toString()}-book';
    return Container(
        key: Key(keyValue),
        margin: EdgeInsets.fromLTRB(12, 4, 12, 0),
        child: Material(
            elevation: 4,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReservationDetails(reservation: this.reservation),
                ),
              ),
              enableFeedback: true,
              child: RowContainer(
                  color: Theme.of(context).backgroundColor,
                  child: Container(
                      padding: EdgeInsets.all(12.0),
                      child: IntrinsicHeight(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Hero(
                              tag: book.title,
                              child: Image.network(
                                book.imageURL,
                                width: hs(70, context),
                                height: vs(105, context),
                                fit: BoxFit.fill,
                              ),
                          ),
                          buildLibraryContainerBody(context)
                        ],
                      )))),
            )));
  }

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
