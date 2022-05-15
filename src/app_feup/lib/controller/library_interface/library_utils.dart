final String catalogUrl = 'https://catalogo.up.pt';

final String testUrl =
    'https://catalogo.up.pt/F/?func=find-b&request=Design+Patterns';

// TODO change the EUP to the faculty
final String reservationUrl =
    'https://catalogo.up.pt:443/F/?func=bor-history-loan&adm_library=EUP50';

final String baseUrl = 'https://catalogo.up.pt/F';
String baseSearchUrl(String query) =>
    'https://catalogo.up.pt/F/?func=find-b&request=$query';

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
