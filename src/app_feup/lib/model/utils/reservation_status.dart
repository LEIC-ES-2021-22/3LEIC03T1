enum ReservationStatus {
  pending,
  readyForCollection,
  collected,
  delayed,
  finished
}

/**
 * Did not finish this method since I don't think we will need it
 */
ReservationStatus parseReservationStatus(String str) {
  str = str.toLowerCase();
  if (str == 'pendente') {
    return ReservationStatus.pending;
  } else if (str == 'pronto para recolha') {
    return ReservationStatus.readyForCollection;
  } else {
    return null;
  }
}

String toString(ReservationStatus status) {
  switch (status) {
    case ReservationStatus.pending:
      return 'Pendente';
    case ReservationStatus.readyForCollection:
      return 'Pronto para recolha';
    case ReservationStatus.collected:
      return 'Recolhido';
    case ReservationStatus.delayed:
      return 'Atrasada';
    case ReservationStatus.finished:
      return 'Terminada';
  }
  return 'Desconhecido';
}
