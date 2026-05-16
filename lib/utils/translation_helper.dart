import 'package:translator/translator.dart';

class TranslationHelper {
  static final _translator = GoogleTranslator();

  static Future<Map<String, String>> translateToAll(String input, String sourceLang) async {
    String en = input;
    String hi = input;
    String gu = input;

    try {
      if (sourceLang == 'en') {
        hi = (await _translator.translate(input, to: 'hi')).text;
        gu = (await _translator.translate(input, to: 'gu')).text;
      } else if (sourceLang == 'hi') {
        en = (await _translator.translate(input, to: 'en')).text;
        gu = (await _translator.translate(input, to: 'gu')).text;
      } else if (sourceLang == 'gu') {
        en = (await _translator.translate(input, to: 'en')).text;
        hi = (await _translator.translate(input, to: 'hi')).text;
      }
    } catch (e) {
      // In case of offline or error, just fallback to same string
    }

    return {
      'en': en,
      'hi': hi,
      'gu': gu,
    };
  }

  static String toLocalDigits(String input, String lang) {
    if (lang == 'en') return input;
    
    const List<String> hiDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
    const List<String> guDigits = ['૦', '૧', '૨', '૩', '૪', '૫', '૬', '૭', '૮', '૯'];
    
    final targetDigits = lang == 'hi' ? hiDigits : guDigits;
    
    String result = '';
    for (int i = 0; i < input.length; i++) {
      int? num = int.tryParse(input[i]);
      if (num != null) {
        result += targetDigits[num];
      } else {
        result += input[i];
      }
    }
    return result;
  }
}
