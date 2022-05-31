import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/book.dart';
import 'package:uni/model/utils/reservation_status.dart';

class BookReservation {
  int reservationNumber;
  DateTime acquisitionDate;
  DateTime returnDate;
  String pickupLocation;
  ReservationStatus status;

  Book book;

  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  BookReservation(
      {this.reservationNumber,
      this.acquisitionDate,
      this.returnDate,
      this.pickupLocation,
      this.status,
      this.book});

  String getDateIndicator() {
    switch (this.status) {
      case ReservationStatus.pending:
        return ' - ';
      case ReservationStatus.finished:
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

  String getReturnDate() {
    return formatter.format(this.returnDate);
  }

  String getAcquisitionDate() {
    return formatter.format(this.acquisitionDate);
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
    return '''
      $reservationNumber - $acquisitionDate - $returnDate - $pickupLocation - $status - \
      ''' +
        this.book.toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookReservation &&
          runtimeType == other.runtimeType &&
          reservationNumber == other.reservationNumber &&
          acquisitionDate == other.acquisitionDate &&
          returnDate == other.returnDate &&
          pickupLocation == other.pickupLocation &&
          this.book == other.book;

  @override
  int get hashCode =>
      reservationNumber.hashCode ^
      acquisitionDate.hashCode ^
      returnDate.hashCode ^
      pickupLocation.hashCode ^
      this.book.hashCode;
}
