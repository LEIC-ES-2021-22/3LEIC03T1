import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uni/model/entities/book.dart';
import 'package:uni/view/Pages/book_details_page_view.dart';
import 'package:uni/view/Widgets/generic_library_container.dart';

enum BookContainerType { searchResult, reservation }

class BookContainer extends GenericLibraryContainer {
  @override
  final Book book;

  BookContainer({Key key, @required this.book}) : super(key: key, book: book);

  @override
  Widget buildLibraryContainerBody(BuildContext context) {
    return Expanded(
        child: Container(
            margin: EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(height: 5),
                Text(book.author,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .apply(fontSizeDelta: -2)),
                Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        margin: EdgeInsets.only(bottom: 5),
                        child: book.unitsAvailable != null
                            ? Text(
                          book.getUnitsText(),
                          style: book.unitsAvailable != 1
                              ? Theme.of(context).textTheme.bodyText2
                              : Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .apply(color: Colors.red[700]),
                        )
                            : Text('Disponibilidade desconhecida',
                                style: Theme.of(context).textTheme.bodyText2),
                      ),
                      buildBookTypesContainer(context)
                    ]))
              ],
            )));
  }

  Widget buildBookTypesContainer(BuildContext context) {
    final List<Widget> iconList = [];
    if (book.hasPhysicalVersion) {
      iconList.add(Icon(Icons.menu_book));
      if (book.hasDigitalVersion) iconList.add(SizedBox(width: 3));
    }

    if (book.hasDigitalVersion) iconList.add(Icon(Icons.file_download));

    return Container(
      alignment: Alignment.bottomRight,
      child: Row(
        children: iconList,
      ),
    );
  }

  @override
  void onClick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetails(book: this.book),
      ),
    );
  }
}

