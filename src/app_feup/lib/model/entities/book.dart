class Book {
  String title;
  String author;
  String editor;
  String releaseYear;
  String language;
  String country;

  int unitsAvailable;
  int totalUnits;

  bool hasPhysicalVersion;
  bool hasDigitalVersion;

  String digitalURL;
  String imageURL;
  String documentType;
  String isbnCode;
  List<String> themes;

  Book(
      this.title,
      this.author,
      this.editor,
      this.releaseYear,
      this.language,
      this.country,
      this.unitsAvailable,
      this.totalUnits,
      this.hasPhysicalVersion,
      this.hasDigitalVersion,
      this.digitalURL,
      this.imageURL,
      this.documentType,
      this.isbnCode,
      this.themes);
}
