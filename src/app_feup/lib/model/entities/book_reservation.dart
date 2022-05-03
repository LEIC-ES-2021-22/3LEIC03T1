import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:uni/model/utils/reservation_status.dart';

class BookReservation {
  String title;
  String author;

  String language;
  String country;

  int reservationNumber;
  DateTime acquisitionDate;
  DateTime returnDate;
  String pickupLocation;
  ReservationStatus status;

  int unitsAvailable;
  int totalUnits;

  bool hasPhysicalVersion;
  bool hasDigitalVersion;

  String digitalURL;
  String imageURL;
  String documentType;
  String isbnCode;

  BookReservation({
    this.title,
    this.author,
    this.language,
    this.country,
    this.reservationNumber,
    this.acquisitionDate,
    this.returnDate,
    this.pickupLocation,
    this.status,
    this.unitsAvailable,
    this.totalUnits,
    this.hasPhysicalVersion,
    this.hasDigitalVersion,
    this.digitalURL,
    this.imageURL,
    this.documentType,
    this.isbnCode,
  });

  String getUnitsText() {
    if (unitsAvailable == 1) return '1 unidade';
    return '$unitsAvailable unidades';
  }

  String getDateIndicator() {
    switch (this.status) {
      case ReservationStatus.pending:
      case ReservationStatus.finished:
        final DateFormat formatter = DateFormat('dd-MM-yyyy');
        return formatter.format(this.acquisitionDate) +
            ' - ' +
            formatter.format(this.returnDate);
      case ReservationStatus.readyForCollection:
      case ReservationStatus.collected:
        final int remainingDays =
            this.returnDate.difference(DateTime.now()).inDays;

        if (remainingDays == 1) return 'Falta 1 dia';
        return 'Faltam $remainingDays dias';
      case ReservationStatus.delayed:
        final int delayedDays =
            DateTime.now().difference(this.returnDate).inDays;

        if (delayedDays == 1) return '1 dia em atraso';
        return '$delayedDays dias em atraso';
    }
    return '';
  }

  Color getStatusColor() {
    switch (this.status) {
      case ReservationStatus.pending:
      case ReservationStatus.finished:
        return Colors.grey[600];
      case ReservationStatus.readyForCollection:
      case ReservationStatus.collected:
        final int remainingDays =
            this.returnDate.difference(DateTime.now()).inDays;

        if (remainingDays <= 3) return Colors.yellow[500];
        return Colors.green[500];
      case ReservationStatus.delayed:
        return Colors.red[700];
    }

    return Colors.grey[500];
  }

  @override
  String toString() {
    return '''$title - $author - $language - $country - \
      $reservationNumber - $acquisitionDate - $returnDate - $pickupLocation - \
      $unitsAvailable - $totalUnits - $hasPhysicalVersion - $hasDigitalVersion - \
      $digitalURL - $imageURL - $documentType - $isbnCode''';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookReservation &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          author == other.author &&
          language == other.language &&
          country == other.country &&
          reservationNumber == other.reservationNumber &&
          acquisitionDate == other.acquisitionDate &&
          returnDate == other.returnDate &&
          pickupLocation == other.pickupLocation &&
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
      language.hashCode ^
      country.hashCode ^
      reservationNumber.hashCode ^
      acquisitionDate.hashCode ^
      returnDate.hashCode ^
      pickupLocation.hashCode ^
      unitsAvailable.hashCode ^
      totalUnits.hashCode ^
      hasPhysicalVersion.hashCode ^
      hasDigitalVersion.hashCode ^
      digitalURL.hashCode ^
      imageURL.hashCode ^
      documentType.hashCode ^
      isbnCode.hashCode;
}
