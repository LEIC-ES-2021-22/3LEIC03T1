class SearchFilters {
  int sortByOption;
  String sortByQuery;

  int languageOption;
  String languageQuery;

  int countryOption;
  String countryQuery;

  int docTypeOption;
  String docTypeQuery;

  String yearQuery;

  SearchFilters(
      {this.sortByOption = 0,
      this.sortByQuery,
      this.languageOption = 0,
      this.languageQuery = '',
      this.countryOption = 0,
      this.countryQuery = '',
      this.docTypeOption = 0,
      this.docTypeQuery = '',
      this.yearQuery = ''});

  bool hasFilters() {
    return languageQuery != '' ||
        countryQuery != '' ||
        docTypeQuery != '' ||
        yearQuery != '';
  }
}
