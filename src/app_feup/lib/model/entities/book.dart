import 'dart:collection';
import 'package:collection/collection.dart';


class Book{
  final String author;
  final String title;
  final DateTime date;
  final String imagePath;
  final bool digitalAvailable;

  // ignore: lines_longer_than_80_chars
  Book({String this.author, String this.title, DateTime this.date, String this.imagePath, bool this.digitalAvailable});
}
