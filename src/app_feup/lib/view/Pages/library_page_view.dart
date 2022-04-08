import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/form_text_field.dart';

class LibraryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LibraryPageState();
}

class LibraryPageState extends SecondaryPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 400),
      alignment: Alignment.center,
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Biblioteca',
              style:
                  Theme.of(context).textTheme.headline6.apply(fontSizeDelta: 7),
            ),
            Material(
                child: ElevatedButton(
                    child: Text('Reservas'),
                    onPressed: () {
                      debugPrint('clicked reservations');
                    })),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
              child: FormTextField(
            TextEditingController(),
            Icons.search,
            minLines: 1,
            maxLines: 2,
            labelText: 'Pesquisa de Livros',
          )),
          IconButton(
            icon: Icon(Icons.tune, color: Theme.of(context).accentColor),
            onPressed: () {
              debugPrint('clicked icon');
            },
          )
        ])
      ]),
    );
  }
}
