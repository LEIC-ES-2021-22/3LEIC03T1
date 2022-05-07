enum ReservationStatus {
  pending,
  readyForCollection,
  collected,
  delayed,
  finished
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
