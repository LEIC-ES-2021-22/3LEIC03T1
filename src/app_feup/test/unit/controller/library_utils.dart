import 'package:flutter_test/flutter_test.dart';
import 'package:uni/controller/library/library_utils.dart';
import 'package:uni/model/entities/search_filters.dart';

void main() {
  group('Base Search URL', () {
    test('When only a query is given', () {
      final String query = 'testQuery';
      final String url = baseSearchUrl(query, SearchFilters());

      expect(url,
          'https://catalogo.up.pt/F/?func=find-b&request=$query&find_code=WRD');
    });

    test('When query and search filters are given', () {
      final String query = 'testQuery';
      final String url = baseSearchUrl(
          query, SearchFilters(languageQuery: 'PT', countryQuery: 'POR'));

      expect(
          url,
          'https://catalogo.up.pt/F/?func=find-b&request=$query' +
              '&find_code=WRD&filter_code_1=WLN&filter_request_1=PT&filter_code_2=WCN&filter_request_2=POR');
    });
  });

  group('Build UP', () {
    test('When given the up string', () {
      final String result = buildUp('up1234');
      expect(result, 'up1234');
    });

    test('When not given the up string', () {
      final String result = buildUp('1234');
      expect(result, 'up1234');
    });
  });

  group('Search Filters', () {
    test('When there are filter queries specified', () {
      final SearchFilters filters =
          SearchFilters(languageQuery: 'PT', countryQuery: 'POR');
      expect(filters.hasFilters(), true);
    });

    test('When there are no filters specified', () {
      final SearchFilters filters = SearchFilters();
      expect(filters.hasFilters(), false);
    });

    test('When there are only filter options specified', () {
      final SearchFilters filters =
          SearchFilters(languageOption: 1, countryOption: 0);
      expect(filters.hasFilters(), false);
    });
  });

  group('Date Parsing', () {
    test('When given a date with the catalog format', () {
      final String date = '01/Jan/2019';
      final DateTime result = parseDate(date);
      expect(result.year, 2019);
      expect(result.month, 1);
      expect(result.day, 1);
    });
  });
}
