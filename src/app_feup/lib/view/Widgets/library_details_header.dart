import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uni/utils/methods.dart';

class LibraryDetailsHeader extends StatelessWidget {
  final String heroTag;
  final String bookUrl;
  final List<Widget> headerInfo;
  final List<Widget> btnWidgets;
  final String headerTitle;

  LibraryDetailsHeader(
      {Key key,
      this.headerTitle,
      this.heroTag,
      this.bookUrl,
      this.headerInfo,
      this.btnWidgets});

  @override
  Widget build(BuildContext context) {
    final grayAreaHeight = vs(210, context);
    final fullWidth = hs(MediaQuery.of(context).size.width, context);
    final btnsHeight = vs(45, context);
    final topContainerHeight = grayAreaHeight + btnsHeight;

    return Container(
      height: topContainerHeight,
      width: fullWidth,
      child: Stack(children: [
        Container(
            height: grayAreaHeight,
            width: fullWidth,
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2),
                    topRight: Radius.circular(2),
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: Offset(hs(4, context),
                        vs(3, context)), // changes position of shadow
                  ),
                ]),
            child: Container(
              padding:
                  EdgeInsets.fromLTRB(hs(20, context), vs(10, context), 0, 0),
              child: Column(
                key: Key('reservationDetailsCol'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      this.headerTitle,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(height: vs(15, context)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: this.heroTag,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 4,
                                blurRadius: 2,
                                offset:
                                    Offset(2, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: SizedBox.fromSize(
                                  //size: Size.fromRadius(55), // Image radius
                                  child: Image.network(
                                this.bookUrl,
                                width: hs(100, context),
                                height: vs(140, context),
                                fit: BoxFit.fill,
                              ))),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(hs(15, context),
                              vs(15, context), hs(7, context), vs(0, context)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: this.headerInfo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
        Positioned(
            top: grayAreaHeight - btnsHeight / 2,
            left: fullWidth / 2,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: this.btnWidgets,
              ),
            )),
      ]),
    );
  }
}
