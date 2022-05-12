import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/controller/library/library.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/action_creators.dart';
import 'package:uni/view/Pages/library_reservations_page_view.dart';
import 'package:uni/view/Widgets/search_filter_form.dart';

class LibrarySearchHeader extends StatefulWidget {
  @override
  _LibrarySearchHeaderState createState() => _LibrarySearchHeaderState();
}

class _LibrarySearchHeaderState extends State<LibrarySearchHeader> {
  static final FocusNode searchNode = FocusNode();
  static final TextEditingController searchController = TextEditingController();
  static final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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
              'Biblioteca',
              style:
                  Theme.of(context).textTheme.headline6.apply(fontSizeDelta: 7),
            ),
            Material(
                child: ElevatedButton(
                    child: Text('Reservas'),
                    key: Key('reservationsButton'),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LibraryReservations()));
                    })),
          ],
        ),
        SizedBox(height: 15),
        createSearchOptions(context),
      ]),
    );
  }

  Widget createSearchOptions(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [createSearchBar(context), createSearchFilters(context)]);
  }

  Widget createSearchBar(BuildContext context) {
    return Flexible(
        child: Form(
      key: _formkey,
      child: TextFormField(
        style: TextStyle(color: Colors.black, fontSize: 18),
        controller: searchController,
        autofocus: false,
        focusNode: searchNode,
        onFieldSubmitted: (term) {
          searchNode.unfocus();
          StoreProvider.of<AppState>(context).dispatch(
              getLibraryBooks(Completer(), Library(), searchController.text));
        },
        textInputAction: TextInputAction.done,
        textAlign: TextAlign.left,
        decoration: searchBarInputDecoration(context, 'Procure'),
        // Key for flutter_gherkin
        key: Key('searchBar'),
      ),
    ));
  }

  Widget createSearchFilters(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: IconButton(
        icon: Icon(Icons.tune, color: Theme.of(context).accentColor),
        onPressed: () {
          showDialog(context: context, builder: getSearchFiltersForm);
        },
        tooltip: 'Filtros de Pesquisa',
        iconSize: 28,
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      ),
    );
  }

  Widget getSearchFiltersForm(BuildContext context) {
    return SearchFilterForm();
  }

  InputDecoration searchBarInputDecoration(
      BuildContext context, String placeholder) {
    return InputDecoration(
        // Key for flutter_gherkin
        icon: Icon(Icons.search, color: Colors.grey, key: Key('search')),
        hintText: placeholder,
        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).accentColor, width: 1)));
  }
}
