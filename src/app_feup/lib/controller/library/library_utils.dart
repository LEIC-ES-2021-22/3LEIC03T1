import 'package:intl/intl.dart';
import 'package:uni/model/entities/search_filters.dart';

final int numberDays = 15;

final String catalogUrl = 'https://catalogo.up.pt';

final String testUrl =
    'https://catalogo.up.pt/F/?func=find-b&request=Design+Patterns';

final String postUrl = 'https://catalogo.up.pt/F/'; // Always the same URL

String newsUrl() {
  final DateTime now = DateTime.now();
  final DateTime oldDays = now.subtract(Duration(days: numberDays));
  final String formattedNow = DateFormat('yyyyMMdd').format(now);
  final String formattedOld = DateFormat('yyyyMMdd').format(oldDays);

  return 'https://catalogo.up.pt/F/?func=find-c&ccl_term=WDT=$formattedOld->$formattedNow&sort_option=07---D';
}

String getFacultyBaseUrl(String faculty) {
  return 'https://catalogo.up.pt/F/?func=find-b-0&local_base=$faculty';
}

String loginUrl(String faculty) {
  final String facCode = libraryFacCodes[faculty];
  return 'https://catalogo.up.pt/shib/$facCode/pds_main?func=load-login&calling_system=aleph&institute=$facCode&PDS_HANDLE=&url=https://catalogo.up.pt:443/F/?func=BOR-INFO/';
}

String reservationUrl(String faculty, String pdsHandle) {
  final String facCode = libraryFacCodes[faculty];
  return 'https://catalogo.up.pt:443/F/?func=bor-hold&adm_library=$facCode&pds_handle=$pdsHandle';
}

String reservationHistoryUrl(String faculty, String pdsHandle) {
  final String facCode = libraryFacCodes[faculty];
  return 'https://catalogo.up.pt:443/F/?func=bor-history-hold&adm_library=$facCode&pds_handle=$pdsHandle';
}

String bookDetailsUrl(String docNumber) {
  return 'https://catalogo.up.pt/F/?func=direct&doc_number=$docNumber';
}

final String baseUrl = 'https://catalogo.up.pt/F';

String baseSearchUrl(String query, SearchFilters filters) {
  String url =
      'https://catalogo.up.pt/F/?func=find-b&request=$query&find_code=WRD';

  if (filters.languageQuery != null && filters.languageQuery != '') {
    url += '&filter_code_1=WLN&filter_request_1=' + filters.languageQuery;
  }

  if (filters.countryQuery != null && filters.countryQuery != '') {
    url += '&filter_code_2=WCN&filter_request_2=' + filters.countryQuery;
  }

  if (filters.yearQuery != null && filters.yearQuery != '') {
    url += '&filter_code_3=WYR&filter_request_3=' + filters.yearQuery;
  }

  if (filters.docTypeQuery != null && filters.docTypeQuery != '') {
    url += '&filter_code_5=WFMT&filter_request_5=' + filters.docTypeQuery;
  }

  return url;
}

String catalogBookUrl(String book) => 'https://catalogo.up.pt$book';

String gBookUrl(String isbn) =>
    'https://media.springernature.com/w153/springer-static/cover/book/$isbn.jpg';

final cookieRegex = RegExp(r'(?<=^|\S,).*?(?=$|,\S)');

final Map<String, String> libraryFacCodes = {
  'faup': 'UPB56',
  'fbaup': 'UPB55',
  'fcup': 'FCB50',
  'fcnaup': 'UPB54',
  'fadeup': 'UPB52',
  'fdup': 'UPB51',
  'fep': 'FEP50',
  'feup': 'EUP50',
  'ffup': 'UPB58',
  'flup': 'FLP50',
  'fmup': 'MED50',
  'fmdup': 'UPB71',
  'fpceup': 'UPB53',
  'icbas': 'UPB58'
};

String buildUp(String username) {
  String res = username;
  if (res.substring(0, 2) != 'up') {
    res = 'up' + res;
  }
  return res;
}

final Map<String, String> facInitials = {
  'faup': 'arq',
  'fbaup': 'fba',
  'fcup': 'fc',
  'fcnaup': 'fcna',
  'fadeup': 'fade',
  'fdup': 'fd',
  'fep': 'fep',
  'feup': 'fe',
  'ffup': 'ff',
  'flup': 'fl',
  'fmup': 'med',
  'fmdup': 'med',
  'fpceup': 'fpce',
  'icbas': 'icbas'
};

final Map<String, String> monthToNum = {
  'Jan': '01',
  'Fev': '02',
  'Mar': '03',
  'Abr': '04',
  'Mai': '05',
  'Jun': '06',
  'Jul': '07',
  'Ago': '08',
  'Set': '09',
  'Out': '10',
  'Nov': '11',
  'Dez': '12',
};

/**
 * Receives a Date with the libraries' format and returns a DateTime
 */
DateTime parseDate(String libraryDate) {
  final List<String> data = libraryDate.split('/');
  return DateTime.parse(data[2] + '-' + monthToNum[data[1]] + '-' + data[0]);
}
