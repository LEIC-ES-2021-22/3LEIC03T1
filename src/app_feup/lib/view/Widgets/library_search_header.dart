import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uni/view/Widgets/search_filter_form.dart';

class LibrarySearchHeader extends StatefulWidget {
  @override
  _LibrarySearchHeaderState createState() => _LibrarySearchHeaderState();
}

class _LibrarySearchHeaderState extends State<LibrarySearchHeader> {
  static final FocusNode searchNode = FocusNode();
  static final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 400), // TODO Change padding
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
      child: TextFormField(
        style: TextStyle(color: Colors.white, fontSize: 20),
        controller: searchController, // TODO Fix page refreshing on focus
        autofocus: false,
        focusNode: searchNode,
        onFieldSubmitted: (term) {
          searchNode.unfocus();
          // TODO Search action
        },
        textInputAction: TextInputAction.done,
        textAlign: TextAlign.left,
        decoration: searchBarInputDecoration(context, 'Procure'),
        validator: (String value) =>
            value.isEmpty ? 'Preencha este campo' : null,
      ),
    );
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
        icon: Icon(Icons.search),
        hintText: placeholder,
        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).accentColor, width: 2)));
  }
}
