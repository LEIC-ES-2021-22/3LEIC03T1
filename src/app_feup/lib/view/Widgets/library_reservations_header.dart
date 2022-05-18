import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uni/view/Pages/library_page_view.dart';

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
                  // ignore: lines_longer_than_80_chars
                  Theme.of(context).textTheme.headline6.apply(fontSizeDelta: 12),
            ),
            Material(
                child: ElevatedButton(
                    child: Text('Catálogo'),
                    key: Key('catalogButton'),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LibraryPage()));
                    })),
          ],
        ),
        SizedBox(height: 15),
      ]),
    );
  }
}
