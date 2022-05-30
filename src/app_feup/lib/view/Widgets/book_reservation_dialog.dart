import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:uni/controller/library/library.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/book.dart';
import 'package:uni/utils/methods.dart';
import 'package:redux/redux.dart';

class BookReservationDialog extends StatefulWidget {
  BookReservationDialog({Key key, @required this.book}) : super(key: key);

  final Book book;

  @override
  State<StatefulWidget> createState() {
    return _BookReservationDialogState(book: book);
  }
}

class _BookReservationDialogState extends State<BookReservationDialog> {
  TextEditingController beginDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  String beginDate;
  String endDate;
  String notes;
  bool isUrgent;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isButtonTapped = false;
  String catalogError = '';
  final Book book;

  _BookReservationDialogState({@required this.book});

  Widget _buildBeginDateField() {
    return TextFormField(
      controller: beginDateController,
      //editing controller of this TextField
      decoration: InputDecoration(
          icon: Icon(Icons.calendar_today, color: Colors.grey),
          labelText: 'Data de Início',
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1))),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Este campo é obrigatório';
        }
        return null;
      },
      onSaved: (String value) {
        beginDate = value;
      },
      readOnly: true,
      //set it true, so that user will not able to edit text
      onTap: () async {
        final DateTime pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(DateTime.now().year + 1));

        if (pickedDate != null) {
          final String formattedDate =
              DateFormat('dd-MM-yyyy').format(pickedDate);

          setState(() {
            beginDateController.text =
                formattedDate; //set output date to TextField value.
          });
        }
      },
    );
  }

  Widget _buildEndDateField() {
    return TextFormField(
      controller: endDateController,
      //editing controller of this TextField
      decoration: InputDecoration(
          icon: Icon(Icons.calendar_today, color: Colors.grey),
          labelText: 'Data de Devolução',
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1))),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Este campo é obrigatório';
        }
        return null;
      },
      onSaved: (String value) {
        endDate = value;
      },
      readOnly: true,
      //set it true, so that user will not able to edit text
      onTap: () async {
        final DateTime pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(DateTime.now().year + 1));

        if (pickedDate != null) {
          final String formattedDate =
              DateFormat('dd-MM-yyyy').format(pickedDate);

          setState(() {
            endDateController.text =
                formattedDate; //set output date to TextField value.
          });
        }
      },
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      maxLines: 5,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(10.0),
        hintText: 'Notas',
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      keyboardType: TextInputType.multiline,
    );
  }

  Widget _buildIsUrgentField() {
    return CheckboxListTile(
      title: Text('Urgent'),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.all(0),
      value: isUrgent,
      onChanged: (bool value) {
        setState(() {
          isUrgent = value;
        });
      },
    );
  }

  @override
  void initState() {
    isUrgent = false;
    super.initState();
  }

  List<Widget> createFormField() {
    final List<Widget> formWidgets = [];

    if (catalogError != '') {
      formWidgets.add(
        Text(
          'Occorreu um erro :(',
          style: TextStyle(color: Colors.red),
        ),
      );
      formWidgets.add(SizedBox(height: 5));
      formWidgets.add(
        Text(
          'Por favor, tente reservar em catalogo.up.pt',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    formWidgets.add(_buildBeginDateField());
    formWidgets.add(SizedBox(
      height: 15,
    ));
    formWidgets.add(_buildEndDateField());
    formWidgets.add(SizedBox(
      height: 50,
    ));
    formWidgets.add(_buildNotesField());
    formWidgets.add(SizedBox(
      height: 15,
    ));
    formWidgets.add(_buildIsUrgentField());

    return formWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Reserva do Livro')),
      content: Container(
        constraints: BoxConstraints(maxHeight: 370),
        height: vs(350.0, context),
        width: hs(250.0, context),
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: _isButtonTapped
            ? Container(
                padding: EdgeInsets.all(22.0),
                child: Center(child: CircularProgressIndicator()))
            : Form(
                key: _formKey,
                child: ListView(
                  children: createFormField(),
                ),
              ),
      ),
      actions: [
        TextButton(
          child: Text('SUBMIT'),
          onPressed: submitReservationForm,
        ),
        TextButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  void submitReservationForm() async {
    if (!_formKey.currentState.validate() || _isButtonTapped) {
      return;
    }

    setState(() {
      _isButtonTapped = true;
    });

    _formKey.currentState.save();
    final Store<AppState> store = StoreProvider.of<AppState>(context);

    final Library library = await Library.create(
        store: store, pdsCookie: store
            .state
            .content['catalogPdsCookie']);

    final String error = await library.reserveBook(
      beginDate, endDate, notes, isUrgent, book
    );

    if (error == '') {
      Navigator.of(context).pop();
    }

    setState(() {
      _isButtonTapped = false;
      catalogError = error;
    });
  }
}
