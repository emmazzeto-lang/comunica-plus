import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_appbar.dart';
import 'services/tts_services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ComecarScreen extends StatefulWidget {
  final String genero;

  const ComecarScreen({
    super.key,
    required this.genero,
  });

  @override
  State<ComecarScreen> createState() => _ComecarScreenState();
}

class _ComecarScreenState extends State<ComecarScreen> {
  final TtsService tts = TtsService();
  List<Map<String, dynamic>> fraseAtual = [];
  String categoriaAtiva = "Pessoas";

  final List<String> categorias = ["Pessoas", "Comida", "Ações", "Sentimentos", "Objetos", "Alfabeto"];

  // Aqui guardamos as cartas antigas + as novas criadas pelo usuário
  Map<String, List<Map<String, dynamic>>> cartasDinamicas = {};

  // =====================================================================
  // INICIALIZADOR DA TELA (ADICIONADO E CORRIGIDO)
  // =====================================================================
  @override
  void initState() {
    super.initState();
    // Carrega os cards customizados do SharedPreferences assim que a tela abre
    _carregarCartas();
  }

  // =====================================================================
  // FUNÇÃO DE MISTURA DOS CARDS (ADICIONADO)
  // =====================================================================
  Future<void> _carregarCartas() async {
    // 1. Clona o banco original para não misturar de forma permanente na memória
    Map<String, List<Map<String, dynamic>>> bancoTemporario = {};
    bancoDeCartas.forEach((chave, valor) {
      bancoTemporario[chave] = List<Map<String, dynamic>>.from(valor);
    });

    // 2. Busca o arquivo de cartas customizadas salvo no aparelho
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartasJson = prefs.getString('cartas_customizadas');

    if (cartasJson != null) {
      List<dynamic> decodificado = jsonDecode(cartasJson);

      // 3. Distribui cada carta nova criada para a sua respectiva categoria
      for (var item in decodificado) {
        String cat = item['categoria'];
        if (bancoTemporario.containsKey(cat)) {
          bancoTemporario[cat]!.add(Map<String, dynamic>.from(item));
        }
      }
    }

    // 4. Atualiza o estado para redesenhar a tela com os novos cards inclusos
    setState(() {
      cartasDinamicas = bancoTemporario;
    });
  }

  // =====================================================================
  // BANCO DE DADOS FIXO
  // =====================================================================
  final Map<String, List<Map<String, dynamic>>> bancoDeCartas = {
    "Pessoas": [
      {"texto": "Eu", "emoji": "✋"},
      {"texto": "Ela", "emoji": "👩"},
      {"texto": "Ele", "emoji": "👨"},
      {"texto": "Mãe", "emoji": "👩‍🍼"},
      {"texto": "Pai", "emoji": "👨‍🍼"},
      {"texto": "Professora", "emoji": "👩‍🏫"},
    ],
    "Comida": [
      {"texto": "Maçã", "emoji": "🍎"},
      {"texto": "Banana", "emoji": "🍌"},
      {"texto": "Água", "emoji": "💧"},
      {"texto": "Suco", "emoji": "🥤"},
      {"texto": "Leite", "emoji": "🥛"},
      {"texto": "Pão", "emoji": "🍞"},
      {"texto": "Pizza", "emoji": "🍕"},
      {"texto": "Bolacha", "emoji": "🍪"},
    ],
    "Ações": [
      {"texto": "Quero", "emoji": "✋"},
      {"texto": "Brincar", "emoji": "🧸"},
      {"texto": "Comer", "emoji": "🍽️"},
      {"texto": "Beber", "emoji": "🚰"},
      {"texto": "Dormir", "emoji": "🛏️"},
      {"texto": "Banheiro", "emoji": "🚽"},
      {"texto": "Banho", "emoji": "🛁"},
    ],
    "Sentimentos": [
      {"texto": "Feliz", "emoji": "😄"},
      {"texto": "Triste", "emoji": "😢"},
      {"texto": "Bravo", "emoji": "😠"},
      {"texto": "Sono", "emoji": "🥱"},
      {"texto": "Medo", "emoji": "😨"},
    ],
    "Objetos": [
      {"texto": "Brinquedo", "emoji": "🧩"},
      {"texto": "Bola", "emoji": "⚽"},
      {"texto": "Mochila", "emoji": "🎒"},
      {"texto": "Lápis", "emoji": "✏️"},
      {"texto": "Tablet", "emoji": "📱"},
    ],
    "Alfabeto": [
      {"texto": "A", "emoji": "A"},
      {"texto": "B", "emoji": "B"},
      {"texto": "C", "emoji": "C"},
      {"texto": "D", "emoji": "D"},
      {"texto": "E", "emoji": "E"},
      {"texto": "F", "emoji": "F"},
      {"texto": "G", "emoji": "G"},
      {"texto": "H", "emoji": "H"},
      {"texto": "I", "emoji": "I"},
      {"texto": "J", "emoji": "J"},
      {"texto": "K", "emoji": "K"},
      {"texto": "L", "emoji": "L"},
      {"texto": "M", "emoji": "M"},
      {"texto": "N", "emoji": "N"},
      {"texto": "O", "emoji": "O"},
      {"texto": "P", "emoji": "P"},
      {"texto": "Q", "emoji": "Q"},
      {"texto": "R", "emoji": "R"},
      {"texto": "S", "emoji": "S"},
      {"texto": "T", "emoji": "T"},
      {"texto": "U", "emoji": "U"},
      {"texto": "V", "emoji": "V"},
      {"texto": "W", "emoji": "W"},
      {"texto": "X", "emoji": "X"},
      {"texto": "Y", "emoji": "Y"},
      {"texto": "Z", "emoji": "Z"},
      {"texto": "0", "emoji": "0️⃣"},
      {"texto": "1", "emoji": "1️⃣"},
      {"texto": "2", "emoji": "2️⃣"},
      {"texto": "3", "emoji": "3️⃣"},
      {"texto": "4", "emoji": "4️⃣"},
      {"texto": "5", "emoji": "5️⃣"},
      {"texto": "6", "emoji": "6️⃣"},
      {"texto": "7", "emoji": "7️⃣"},
      {"texto": "8", "emoji": "8️⃣"},
      {"texto": "9", "emoji": "9️⃣"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/fundo-especial.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(
          titulo: "MONTAR FRASE",
          corFundo: Color(0xFFE0F2F1),
          corTexto: Color(0xFF00695C),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: _buildBarraDeFrase(),
                  ),
                ),
                const SizedBox(height: 12),
                _buildFiltroDeCategorias(),
                const SizedBox(height: 12),
                Expanded(
                  child: _buildGridDeCartas(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================================
  // LOUSA
  // =====================================================================
  Widget _buildBarraDeFrase() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/lousa_base.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Row(
        children: [
          // BOTÃO FALAR VERDE
          InkWell(
            onTap: () async {
              bool usarEspaco = fraseAtual.any((element) => element['texto'].length > 1);
              String frase = fraseAtual.map((e) => e['texto']).join(usarEspaco ? " " : "");

              if (frase.isNotEmpty) {
                await tts.falar(frase);
              }
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFF81C784),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: const Icon(Icons.record_voice_over, size: 34, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),

          // CARTAS NA LOUSA
          Expanded(
            child: fraseAtual.isEmpty
                ? const Center(
                child: Text(
                    "Toque nos botões abaixo...",
                    style: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold, fontSize: 18)
                )
            )
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: fraseAtual.length,
              itemBuilder: (context, index) {
                return _buildCardLousa(fraseAtual[index]);
              },
            ),
          ),

          const SizedBox(width: 12),

          // BOTÃO APAGAR VERMELHO
          if (fraseAtual.isNotEmpty)
            InkWell(
              onTap: () {
                setState(() {
                  fraseAtual.removeLast();
                });
              },
              child: Container(
                width: 55,
                height: 55,
                decoration: const BoxDecoration(
                  color: Color(0xFFE57373),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: const Icon(Icons.close, size: 34, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  // =====================================================================
  // PEÇA DA LOUSA (CÓDIGO ANTI-OVERFLOW APLICADO)
  // =====================================================================
  Widget _buildCardLousa(Map<String, dynamic> carta) {
    String texto = carta['texto'] ?? '';
    String emoji = carta['emoji'] ?? '';

    bool isAlfabeto = texto.length == 1;

    return Container(
      width: 130,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/base_card.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: isAlfabeto
          ? Center(
        child: Text(
          emoji,
          style: GoogleFonts.nunito(
              fontWeight: FontWeight.w900,
              fontSize: 36,
              color: Colors.black87
          ),
        ),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                texto.toUpperCase(),
                style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black87),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(emoji, style: const TextStyle(fontSize: 24)),
        ],
      ),
    );
  }

  // =====================================================================
  // CATEGORIAS
  // =====================================================================
  Widget _buildFiltroDeCategorias() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: categorias.map((cat) {
          bool ativa = categoriaAtiva == cat;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: InkWell(
              onTap: () => setState(() => categoriaAtiva = cat),
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/categoria_base.png'),
                    fit: BoxFit.fill,
                    colorFilter: ativa ? null : ColorFilter.mode(Colors.white.withValues(alpha: 0.3), BlendMode.lighten),
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (ativa) ...[
                      const Icon(Icons.check_circle, color: Color(0xFF00695C), size: 18),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      cat.toUpperCase(),
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: ativa ? const Color(0xFF00695C) : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // =====================================================================
  // GRID DE CARTAS (Ajustado para ler a lista dinâmica atualizada)
  // =====================================================================
  Widget _buildGridDeCartas() {
    // MODIFICAÇÃO: Se a lista dinâmica estiver pronta, lê dela. Caso contrário, lê o banco padrão.
    final lista = cartasDinamicas.isNotEmpty
        ? cartasDinamicas[categoriaAtiva] ?? []
        : bancoDeCartas[categoriaAtiva] ?? [];

    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: lista.length,
      itemBuilder: (context, index) => _buildCardCatalogo(lista[index]),
    );
  }

  // =====================================================================
  // CARD DO CATÁLOGO
  // =====================================================================
  Widget _buildCardCatalogo(Map<String, dynamic> carta) {
    String texto = carta['texto'] ?? '';
    String emoji = carta['emoji'] ?? '';

    bool isAlfabeto = texto.length == 1;

    return InkWell(
      onTap: () => setState(() => fraseAtual.add(carta)),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/base_card.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: isAlfabeto
            ? Center(
          child: Text(
            emoji,
            style: GoogleFonts.nunito(
                fontWeight: FontWeight.w900,
                fontSize: 48,
                color: Colors.black87
            ),
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  texto.toUpperCase(),
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}