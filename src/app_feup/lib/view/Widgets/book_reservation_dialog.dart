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
  TextEditingController dateinput = TextEditingController();

  //text editing controller for text field

  @override
  void initState() {
    dateinput.text = "Escolha uma data"; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Reserva do Livro')),
      content: Container(
          padding: EdgeInsets.all(15),
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Data Inicial"
              ),
              TextFormField(
                controller: dateinput,
                //editing controller of this TextField
                decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today, color: Colors.grey), //icon of text field
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1)
                  )
                ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(DateTime.now().year + 1)
                  );

                  if (pickedDate != null) {
                    print(
                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate = DateFormat('dd-MM-yyyy').format(
                        pickedDate);
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    //you can implement different kind of Date Format here according to your requirement


                    setState(() {
                      dateinput.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
              ),
            ],
          )),
      actions: [
        TextButton(
          child: Text('SUBMIT'),
          onPressed: () {
            //TODO: Book Reservation Logic
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}