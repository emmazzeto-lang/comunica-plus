import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TtsService {

  final FlutterTts flutterTts = FlutterTts();

  Future<void> configurarTts() async {

    await flutterTts.setLanguage("pt-BR");

    await flutterTts.setSpeechRate(0.45);

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    String voz =
        prefs.getString('voz') ?? 'menino';

    if (voz == 'menino') {

      await flutterTts.setPitch(0.8);

    } else {

      await flutterTts.setPitch(1.3);
    }
  }

  Future<void> falar(String texto) async {

    await configurarTts();

    await flutterTts.speak(texto);
  }
}