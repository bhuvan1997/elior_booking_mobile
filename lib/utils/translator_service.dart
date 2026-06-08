import 'package:translator/translator.dart';

class TranslationService {
  final GoogleTranslator _translator = GoogleTranslator();

  Future<String> translateText(String text, String targetLang) async {
    if (text.isEmpty) return "";
    try {
      var translation = await _translator.translate(text, to: targetLang);
      return translation.text;
    } catch (e) {
      return text; // fallback to original
    }
  }
}
