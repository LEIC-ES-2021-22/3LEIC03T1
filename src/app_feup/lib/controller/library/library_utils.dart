import 'package:uni/model/entities/search_filters.dart';

final String catalogUrl = 'https://catalogo.up.pt';

final String testUrl =
    'https://catalogo.up.pt/F/?func=find-b&request=Design+Patterns';

String loginUrl(faculty) {
  final String facCode = libraryFacCodes[faculty];
  return 'https://catalogo.up.pt/shib/$facCode/pds_main?func=load-login&calling_system=aleph&institute=$facCode&PDS_HANDLE=&url=https://catalogo.up.pt:443/F/?func=BOR-INFO/';
}

String reservationLoansUrl(faculty, pdsHandle) {
  final String facCode = libraryFacCodes[faculty];
  return 'https://catalogo.up.pt:443/F/?func=bor-history-loan&adm_library=$facCode&pds_handle=$pdsHandle';
}

String reservationsUrl(faculty, pdsHandle) {
  final String facCode = libraryFacCodes[faculty];
  return 'https://catalogo.up.pt:443/F/?func=bor-history-hold&adm_library=$facCode&pds_handle=$pdsHandle';
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
