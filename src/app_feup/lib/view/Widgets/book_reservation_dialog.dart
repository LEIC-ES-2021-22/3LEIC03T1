import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/book.dart';
import 'package:uni/utils/methods.dart';

class bookReservationDialog extends StatefulWidget {
  bookReservationDialog({Key key, @required this.book}) : super(key: key);

  final Book book;

  @override
  State<StatefulWidget> createState() {
    return _bookReservationDialogState();
  }
}

class _bookReservationDialogState extends State<bookReservationDialog> {
  TextEditingController begin_date_controller = TextEditingController();
  TextEditingController end_date_controller = TextEditingController();

  String _begin_date;
  String _end_date;
  String _notes;
  bool _is_urgent;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildBeginDateField() {
    return TextFormField(
      controller: begin_date_controller,
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
        _begin_date = value;
      },
      readOnly: true,
      //set it true, so that user will not able to edit text
      onTap: () async {
        DateTime pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(DateTime.now().year + 1));

        if (pickedDate != null) {
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

          setState(() {
            begin_date_controller.text =
                formattedDate; //set output date to TextField value.
          });
        }
      },
    );
  }

  Widget _buildEndDateField() {
    return TextFormField(
      controller: end_date_controller,
      //editing controller of this TextField
      decoration: InputDecoration(
          icon: Icon(Icons.calendar_today, color: Colors.grey),
          labelText: "Data de Devolução",
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1))),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Este campo é obrigatório';
        }
        return null;
      },
      onSaved: (String value) {
        _begin_date = value;
      },
      readOnly: true,
      //set it true, so that user will not able to edit text
      onTap: () async {
        DateTime pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(DateTime.now().year + 1));

        if (pickedDate != null) {
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

          setState(() {
            end_date_controller.text =
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
      title: Text("Urgent"),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.all(0),
      value: _is_urgent,
      onChanged: (bool value) {
        setState(() {
          _is_urgent = value;
        });
      },
    );
  }

  @override
  void initState() {
    _is_urgent = false;
    super.initState();
  }

  List<Widget> createFormField() {
    final List<Widget> formWidgets = [];

    formWidgets.add(_buildBeginDateField());
    formWidgets.add(SizedBox(height: 15,));
    formWidgets.add(_buildEndDateField());
    formWidgets.add(SizedBox(height: 50,));
    formWidgets.add(_buildNotesField());
    formWidgets.add(SizedBox(height: 15,));
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
          child: Form(
            key: _formKey,
            child: ListView(
                  children: createFormField(),
                ),
          ),
        ),
        actions: [
          TextButton(
            child: Text('SUBMIT'),
            onPressed: () {
              if (!_formKey.currentState.validate()) {
                return;
              }

              _formKey.currentState.save();

              //TODO: Book Reservation Logic
              Navigator.of(context).pop();
            },
          )
        ],
      );
  }
}
