import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/book.dart';

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
          labelText: "Data de Início",
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
          print(
              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
          print(
              formattedDate); //formatted date output using intl package =>  2021-03-16
          //you can implement different kind of Date Format here according to your requirement

          setState(() {
            begin_date_controller.text =
                formattedDate; //set output date to TextField value.
          });
        } else {
          print("Date is not selected");
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
          print(
              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
          print(
              formattedDate); //formatted date output using intl package =>  2021-03-16
          //you can implement different kind of Date Format here according to your requirement

          setState(() {
            end_date_controller.text =
                formattedDate; //set output date to TextField value.
          });
        } else {
          print("Date is not selected");
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
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Reserva do Livro')),
      content: Form(
        key: _formKey,
        child: Container(
            padding: EdgeInsets.all(15),
            height: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBeginDateField(),
                _buildEndDateField(),
                _buildNotesField(),
              ],
            )),
      ),
      actions: [
        TextButton(
          child: Text('SUBMIT'),
          onPressed: () {
            if (!_formKey.currentState.validate()) {
              return;
            }

            _formKey.currentState.save();

            print(_begin_date);
            print(_end_date);
            print(_is_urgent);

            //TODO: Book Reservation Logic
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
