import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class DeepLManager {
  factory DeepLManager() {
    return _singleton;
  }

  DeepLManager._internal();

  static final DeepLManager _singleton = DeepLManager._internal();

  static Future<String> translate(String text, String targetLang = '') async {

    final path = 'https://api.deepl.com/v2/translate';
    final params = {
      'auth_key': 'YOUR_AUTH_KEY',
      'text': text,
      'target_lang': targetLang.toUpperCase(),
    };

    try {
      Response response = await Dio().post(path, data: params, options: Options(
        contentType: Headers.formUrlEncodedContentType,
        responseType: ResponseType.json,
      ));

      if (response.statusCode == 200) {

        Translation translation = Translation.fromJson(response.data);
        if (translation.detectedSourceLanguage.toUpperCase() == targetLang.toUpperCase()) {
          return text;
        }

        await translationBox.put(firstFifty, translation.text);
        return translation.text;
      }
    } catch (e) {
      return text;
    }
    return text;
  }
}
