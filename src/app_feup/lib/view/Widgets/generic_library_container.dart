import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uni/model/entities/book.dart';
import 'package:uni/utils/methods.dart';
import 'package:uni/view/Widgets/row_container.dart';

abstract class GenericLibraryContainer extends StatelessWidget {
  final Book book;

  GenericLibraryContainer({Key key, @required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final keyValue = '${book.toString()}-book';
    return Container(
        key: Key(keyValue),
        margin: EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: Material(
            elevation: 4,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: InkWell(
              onTap: () => onClick(context),
              enableFeedback: true,
              child: RowContainer(
                  color: Theme.of(context).backgroundColor,
                  child: Container(
                      padding: EdgeInsets.all(12.0),
                      child: IntrinsicHeight(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          book.imageURL == null
                              ? Image.asset(
                                  'assets/images/book_placeholder.png',
                                  width: hs(70, context),
                                  height: vs(105, context),
                                  fit: BoxFit.fill)
                              // TODO: Sould we use FileImage like general_page_view?
                              : Image.network(
                                  book.imageURL,
                                  width: hs(70, context),
                                  height: vs(105, context),
                                  fit: BoxFit.fill,
                                ),
                          buildLibraryContainerBody(context)
                        ],
                      )))),
            )));
  }

  Widget buildLibraryContainerBody(BuildContext context);

  Widget onClick(BuildContext context);
}
