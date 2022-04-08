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
        SizedBox(height: 15),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: TextFormField(
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  enableSuggestions: false,
                  autocorrect: false,
                  autofocus: false,
                  controller: TextEditingController(),
                  focusNode: null, // TODO
                  onFieldSubmitted: (term) {
                    // TODO
                  },
                  textInputAction: null, // TODO
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: 'Penis',
                      labelText: 'Procure',
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).accentColor, width: 2))),
                  validator: (String value) =>
                      value.isEmpty ? 'Preenche este campo' : null,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: IconButton(
                  icon: Icon(Icons.tune, color: Theme.of(context).accentColor),
                  onPressed: () {
                    debugPrint('clicked icon');
                  },
                  tooltip: 'Advanced Search',
                  iconSize: 28,
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                ),
              )
            ])
      ]),
    );
  }
}
