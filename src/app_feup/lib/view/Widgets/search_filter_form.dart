import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/library/library.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/search_filters.dart';
import 'package:uni/redux/action_creators.dart';
import 'package:uni/utils/methods.dart';
import 'package:uni/view/Widgets/library_search_header.dart';

class SearchFilterForm extends StatefulWidget {
  @override
  _SearchFilterFormState createState() => _SearchFilterFormState();
}

class _SearchFilterFormState extends State<SearchFilterForm> {
  static final _formKey = GlobalKey<FormState>();

  final Map<int, Tuple2<String, String>> sortByFields = {
    0: Tuple2<String, String>('Ano de lançamento', 'Year'),
    1: Tuple2<String, String>('Título', 'Title'),
    2: Tuple2<String, String>('Autor', 'Author'),
  };

  final Map<int, Tuple2<String, String>> languages = {
    0: Tuple2<String, String>('Todas', 'Any'),
    1: Tuple2<String, String>('Português', 'Portuguese'),
    2: Tuple2<String, String>('Inglês', 'English'),
    3: Tuple2<String, String>('Espanhol', 'Spanish'),
    4: Tuple2<String, String>('Francês', 'French'),
    5: Tuple2<String, String>('Italiano', 'Italian'),
    6: Tuple2<String, String>('Alemão', 'German'),
  };

  final Map<int, Tuple2<String, String>> countries = {
    0: Tuple2<String, String>('Todos', 'Any'),
    1: Tuple2<String, String>('Portugal', 'Portugal'),
    2: Tuple2<String, String>('Brasil', 'Brazil'),
    3: Tuple2<String, String>('Estados Unidos', 'USA'),
    4: Tuple2<String, String>('Inglaterra', 'UK'),
    5: Tuple2<String, String>('Espanha', 'Spain'),
    6: Tuple2<String, String>('França', 'France'),
    7: Tuple2<String, String>('Itália', 'Italy'),
    8: Tuple2<String, String>('Alemanha', 'Germany'),
  };

  final Map<int, Tuple2<String, String>> documentTypes = {
    0: Tuple2<String, String>('Todos', 'Any'),
    1: Tuple2<String, String>('Livro', 'Book'),
    2: Tuple2<String, String>('Periódico', 'Periodic'),
    3: Tuple2<String, String>('Artigo/Capítulo', 'Article'),
    4: Tuple2<String, String>('Trabalho Académico', 'Academic'),
    5: Tuple2<String, String>('Mapa', 'Map'),
    6: Tuple2<String, String>('Recurso Eletrónico', 'Eletronic'),
    7: Tuple2<String, String>('Recurso Visual', 'Visual'),
    8: Tuple2<String, String>('Recurso Áudio', 'Audio'),
    9: Tuple2<String, String>('Recurso Visual', 'Visual'),
    10: Tuple2<String, String>('Recurso Misto', 'Mixed'),
    11: Tuple2<String, String>('Norma', 'Regulation'),
  };

  DropdownFilter sortByFilter;
  DropdownFilter languageFilter;
  DropdownFilter countryFilter;
  DropdownFilter docTypeFilter;

  static final TextEditingController yearController = TextEditingController();
  SearchFilters searchFilters;
  bool updateSearchFilters;

  _SearchFilterFormState() {
    sortByFilter = DropdownFilter(sortByFields, 'Ordenar por');
    languageFilter = DropdownFilter(languages, 'Linguagem');
    countryFilter = DropdownFilter(countries, 'País');
    docTypeFilter = DropdownFilter(documentTypes, 'Tipo de Documento');
    updateSearchFilters = true;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SearchFilters>(
      converter: (store) {
        return store.state.content['bookSearchFilters'];
      },
      builder: (context, searchFilters) {
        if (updateSearchFilters) setSearchFilters(searchFilters);
        return buildFilterForm(context);
      },
    );
  }

  Widget buildFilterForm(BuildContext context) {
    return AlertDialog(
        title: Text(
          'Filtros de Pesquisa',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        actions: [
          TextButton(
              child: Text('Cancelar'), onPressed: () => Navigator.pop(context)),
          ElevatedButton(child: Text('Confirmar'), onPressed: submitFilterForm)
        ],
        content: Container(
          height: vs(350.0, context),
          width: hs(250.0, context),
          child: Form(
              key: _formKey,
              child: ListView(children: getFormWidgets(context))),
        ));
  }

  List<Widget> getFormWidgets(BuildContext context) {
    final List<Widget> formWidgets = [];

    formWidgets.add(dropdownSelector(context, sortByFilter));
    formWidgets.add(dropdownSelector(context, languageFilter));
    formWidgets.add(dropdownSelector(context, countryFilter));
    formWidgets.add(dropdownSelector(context, docTypeFilter));
    formWidgets.add(filterTextField(
        context, 'Ano de lançamento', 'Todos', yearController, true));
    return formWidgets;
  }

  Widget dropdownSelector(BuildContext context, DropdownFilter filter) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            filter.title,
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.left,
          ),
          Row(children: <Widget>[
            Expanded(
                child: DropdownButton(
              hint: Text(filter.title),
              items: filter.optionsList,
              value: filter.selectedOption,
              onChanged: (value) {
                setState(() {
                  filter.selectedOption = value;
                });
              },
              isExpanded: true,
            ))
          ])
        ],
      ),
    );
  }

  // TODO Fix scrolling up when keyboard opens
  Widget filterTextField(BuildContext context, String description,
      String placeholder, TextEditingController controller,
      [bool isNumber = false]) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            description,
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.left,
          ),
          Row(children: <Widget>[
            Expanded(
                child: TextFormField(
              style: Theme.of(context).textTheme.headline6,
              maxLines: 1,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).accentColor),
                ),
                hintText: placeholder,
                hintStyle: Theme.of(context).textTheme.subtitle1,
              ),
              controller: controller,
              keyboardType: isNumber ? TextInputType.number : null,
            ))
          ])
        ],
      ),
    );
  }

  void submitFilterForm() {
    // TODO Update state with filters
    searchFilters.countryOption = countryFilter.selectedOption;
    searchFilters.countryQuery = countries[countryFilter.selectedOption].item2;

    searchFilters.languageOption = languageFilter.selectedOption;
    searchFilters.languageQuery =
        countries[languageFilter.selectedOption].item2;

    searchFilters.docTypeOption = docTypeFilter.selectedOption;
    searchFilters.docTypeQuery = countries[docTypeFilter.selectedOption].item2;

    searchFilters.sortByOption = sortByFilter.selectedOption;
    searchFilters.sortByQuery = countries[sortByFilter.selectedOption].item2;

    searchFilters.yearQuery = yearController.text;

    final String searchQuery = LibrarySearchHeaderState.searchController.text;

    StoreProvider.of<AppState>(context)
        .dispatch(getLibraryBooks(Completer(), Library(), searchQuery));

    this.updateSearchFilters = true;
    Navigator.pop(context);
  }

  void setSearchFilters(SearchFilters searchFilters) {
    this.searchFilters = searchFilters;
    this.updateSearchFilters = false;

    if (searchFilters == null) return;

    if (searchFilters.sortByOption != null) {
      sortByFilter.selectedOption = searchFilters.sortByOption;
    }

    if (searchFilters.languageOption != null) {
      languageFilter.selectedOption = searchFilters.languageOption;
    }

    if (searchFilters.countryOption != null) {
      countryFilter.selectedOption = searchFilters.countryOption;
    }

    if (searchFilters.docTypeOption != null) {
      docTypeFilter.selectedOption = searchFilters.docTypeOption;
    }

    if (searchFilters.yearQuery != null) {
      yearController.text = searchFilters.yearQuery;
    }
  }
}

class DropdownFilter {
  final Map<int, Tuple2<String, String>> optionsMap;
  final List<DropdownMenuItem<int>> optionsList = [];
  String title;
  int selectedOption;

  DropdownFilter(this.optionsMap, this.title) {
    this.selectedOption = 0;
    this.loadOptionsList();
  }

  void loadOptionsList() {
    optionsMap.forEach((int key, Tuple2<String, String> tup) => {
          optionsList.add(DropdownMenuItem(child: Text(tup.item1), value: key))
        });
  }
}
