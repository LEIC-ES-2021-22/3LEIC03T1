import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uni/view/Widgets/generic_library_container.dart';

class BookContainer extends GenericLibraryContainer {
  BookContainer({Key key, @required book}) : super(key: key, book: book);

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
                        child: Text(
                          book.getUnitsText(),
                          style: book.unitsAvailable > 1
                              ? Theme.of(context).textTheme.bodyText2
                              : Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .apply(color: Colors.red[700]),
                        ),
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
}
