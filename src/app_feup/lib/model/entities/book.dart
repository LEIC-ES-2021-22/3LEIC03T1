import 'package:collection/collection.dart';

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
      {this.title,
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
      this.themes});

  @override
  String toString() {
    return '''$title - $author - $editor - $releaseYear - $language - $country - \
      $unitsAvailable - $totalUnits - $hasPhysicalVersion - $hasDigitalVersion - \
      $digitalURL - $imageURL - $documentType - $isbnCode - $themes''';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          author == other.author &&
          editor == other.editor &&
          ListEquality().equals(themes, other.themes) &&
          releaseYear == other.releaseYear &&
          language == other.language &&
          country == other.country &&
          unitsAvailable == other.unitsAvailable &&
          totalUnits == other.totalUnits &&
          hasPhysicalVersion == other.hasPhysicalVersion &&
          hasDigitalVersion == other.hasDigitalVersion &&
          digitalURL == other.digitalURL &&
          imageURL == other.imageURL &&
          documentType == other.documentType &&
          isbnCode == other.isbnCode;

  @override
  int get hashCode =>
      title.hashCode ^
      author.hashCode ^
      editor.hashCode ^
      ListEquality().hash(themes) ^
      releaseYear.hashCode ^
      language.hashCode ^
      country.hashCode ^
      unitsAvailable.hashCode ^
      totalUnits.hashCode ^
      hasPhysicalVersion.hashCode ^
      hasDigitalVersion.hashCode ^
      digitalURL.hashCode ^
      imageURL.hashCode ^
      documentType.hashCode ^
      isbnCode.hashCode;
}
