import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uni/view/Pages/library_reservations_page_view.dart';

class LibraryReservationsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reservas',
              style:
                  Theme.of(context).textTheme.headline6.apply(fontSizeDelta: 7),
            ),
            Material(
                child: ElevatedButton(
                    child: Text('Catálogo'),
                    onPressed: () {
                      // CHANGE THIS TO NAVIGATE TO LIBRARY PAGE
                      Navigator.pop(context);
                    })),
          ],
        ),
        SizedBox(height: 15),
      ]),
    );
  }
}
