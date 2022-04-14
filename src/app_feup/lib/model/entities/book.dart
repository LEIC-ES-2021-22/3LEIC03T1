class Book {
  String author;
  String title;
  DateTime date;
  String imagePath;
  bool digitalAvailable;
  String digitalLink;
  String documentType;

  // ignore: lines_longer_than_80_chars
  Book(String author, String title, DateTime date, String imagePath,
      bool digitalAvailable, String digitalLink, String documentType) {
    this.author = author;
    this.title = title;
    this.date = date;
    this.imagePath = imagePath;
    this.digitalAvailable = digitalAvailable;
    this.digitalLink = digitalLink;
    this.documentType = documentType;
  }
}
