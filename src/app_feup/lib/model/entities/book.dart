class Book {
  String author;
  String title;
  String releaseYear;
  String imagePath;
  bool digitalAvailable;
  String digitalLink;
  String documentType;

  // ignore: lines_longer_than_80_chars
  Book(String author, String title, String releaseYear, String imagePath,
      bool digitalAvailable, String digitalLink, String documentType) {
    this.author = author;
    this.title = title;
    this.releaseYear = releaseYear;
    this.imagePath = imagePath;
    this.digitalAvailable = digitalAvailable;
    this.digitalLink = digitalLink;
    this.documentType = documentType;
  }
}
