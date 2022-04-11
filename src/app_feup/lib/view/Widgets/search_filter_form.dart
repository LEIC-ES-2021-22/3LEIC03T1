import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/view/Widgets/form_text_field.dart';

class SearchFilterForm extends StatefulWidget {
  @override
  _SearchFilterFormState createState() => _SearchFilterFormState();
}

class _SearchFilterFormState extends State<SearchFilterForm> {
  static final _formKey = GlobalKey<FormState>();

  final Map<int, Tuple2<String, String>> sortByFields = {
    0: Tuple2<String, String>('Título', 'Title'),
    1: Tuple2<String, String>('Autor', 'Author'),
    2: Tuple2<String, String>('Ano de lançamento', 'Year'),
  };

  final Map<int, Tuple2<String, String>> languages = {
    0: Tuple2<String, String>('Todos', 'Any'),
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

  SearchFilter sortByFilter;
  SearchFilter languageFilter;
  SearchFilter countryFilter;
  SearchFilter docTypeFilter;
  static final TextEditingController yearController = TextEditingController();

  _SearchFilterFormState() {
    sortByFilter = SearchFilter(sortByFields, 'Ordenar por');
    languageFilter = SearchFilter(languages, 'Linguagem');
    countryFilter = SearchFilter(countries, 'País');
    docTypeFilter = SearchFilter(documentTypes, 'Tipo');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          'Filtros de Pesquisa',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        actions: [
          TextButton(
              child: Text('Cancelar'), onPressed: () => Navigator.pop(context)),
          ElevatedButton(
              child: Text('Confirmar'),
              onPressed: () {
                // TODO Update state with filters
                Navigator.pop(context);
              })
        ],
        content: Container(
          height: 350.0,
          width: 200.0,
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
    formWidgets.add(FormTextField(
      yearController,
      Icons.date_range,
      maxLines: 1,
      description: 'Ano de lançamento',
      labelText: 'Ano',
      bottomMargin: 30.0,
    ));
    return formWidgets;
  }

  Widget dropdownSelector(BuildContext context, SearchFilter filter) {
    return Container(
      margin: EdgeInsets.only(bottom: 30, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            filter.title,
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.left,
          ),
          Row(children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.bug_report,
                  color: Theme.of(context).accentColor,
                )),
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
}

class SearchFilter {
  final Map<int, Tuple2<String, String>> optionsMap;
  final List<DropdownMenuItem<int>> optionsList = [];
  String title;
  int selectedOption;

  SearchFilter(this.optionsMap, this.title) {
    this.selectedOption = 0;
    this.loadOptionsList();
  }

  void loadOptionsList() {
    optionsMap.forEach((int key, Tuple2<String, String> tup) => {
          optionsList.add(DropdownMenuItem(child: Text(tup.item1), value: key))
        });
  }
}
