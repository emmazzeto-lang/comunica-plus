import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TtsService {
  final FlutterTts flutterTts = FlutterTts();

  // O Construtor: Executa a configuração automaticamente assim que a tela carrega
  TtsService() {
    configurarTts();
  }

  Future<void> configurarTts() async {
    await flutterTts.setLanguage("pt-BR");

    // Velocidade levemente ajustada. Como a voz ficará mais aguda,
    // 0.5 costuma ser o ponto ideal para a pronúncia não ficar engolindo letras.
    await flutterTts.setSpeechRate(0.5);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String voz = prefs.getString('voz') ?? 'menino';

    if (voz == 'menino') {
      // Tom agudo moderado: Voz de garotinho
      await flutterTts.setPitch(1.25);
    } else {
      // Tom bem agudo: Voz de menininha fofa
      await flutterTts.setPitch(1.6);
    }
  }

  Future<void> falar(String texto) async {
    // Agora a função é instantânea! Não engasga o clique.
    await flutterTts.speak(texto);
  }

  // Função extra caso você permita a criança trocar o gênero dentro do app sem fechar
  Future<void> recarregarVoz() async {
    await configurarTts();
  }
}