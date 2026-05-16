import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_appbar.dart';
import 'services/tts_services.dart';

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
  List<String> fraseAtual = [];
  String categoriaAtiva = "Comida";
  final List<String> categorias = ["Comida", "Ações", "Sentimentos"];

  final Map<String, List<Map<String, dynamic>>> bancoDeCartas = {
    "Comida": [
      {"texto": "Maçã", "emoji": "🍎"},
      {"texto": "Água", "emoji": "💧"},
      {"texto": "Pizza", "emoji": "🍕"},
      {"texto": "Banana", "emoji": "🍌"},
      {"texto": "Fome", "emoji": "🍽️"},
      {"texto": "Sede", "emoji": "🚰"},
    ],
    "Ações": [
      {"texto": "Eu quero", "emoji": "✋"},
      {"texto": "Brincar", "emoji": "🧸"},
      {"texto": "Dormir", "emoji": "🛏️"},
      {"texto": "Banheiro", "emoji": "🚽"},
    ],
    "Sentimentos": [
      {"texto": "Feliz", "emoji": "😄"},
      {"texto": "Triste", "emoji": "😢"},
      {"texto": "Bravo", "emoji": "😠"},
      {"texto": "Sono", "emoji": "🥱"},
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
            // Margem geral da tela levemente reduzida para dar mais espaço à prancha
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _buildBarraDeFrase(),

                const SizedBox(height: 8), // Espaço reduzido

                _buildFiltroDeCategorias(),

                const SizedBox(height: 8), // Espaço reduzido

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
  // LOUSA OTIMIZADA: Mais fina e elegante
  // =====================================================================
  Widget _buildBarraDeFrase() {
    return Container(
      height: 80, // Altura reduzida de 100 para 80
      padding: const EdgeInsets.all(8), // Padding interno reduzido
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black26, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              String frase = fraseAtual.join(" ");
              if (frase.isNotEmpty) {
                await tts.falar(frase);
              }
            },
            child: Container(
              width: 55, // Botão mais delicado
              decoration: const BoxDecoration(
                color: Color(0xFF81C784),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: const Center(
                child: Icon(Icons.record_voice_over, size: 32, color: Colors.white), // Ícone ajustado
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: fraseAtual.isEmpty
                ? Text(
              'Toque nos botões para formar uma frase...',
              style: GoogleFonts.nunito(fontSize: 18, color: Colors.black38, fontWeight: FontWeight.bold),
            )
                : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              scrollDirection: Axis.horizontal,
              itemCount: fraseAtual.length,
              itemBuilder: (context, index) {
                return _buildCardLousa(fraseAtual[index]);
              },
            ),
          ),

          if (fraseAtual.isNotEmpty)
            InkWell(
              onTap: () {
                setState(() {
                  fraseAtual.removeLast();
                });
              },
              child: Container(
                width: 50, // Botão apagar mais delicado
                decoration: const BoxDecoration(
                  color: Color(0xFFE57373),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: const Center(
                  child: Icon(Icons.backspace, size: 26, color: Colors.white), // Ícone ajustado
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCardLousa(String texto) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00695C), width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        texto,
        style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w900, color: const Color(0xFF00695C)),
      ),
    );
  }

  // =====================================================================
  // FILTRO OTIMIZADO: Mais compacto verticalmente
  // =====================================================================
  Widget _buildFiltroDeCategorias() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: categorias.map((cat) {
          bool isAtiva = categoriaAtiva == cat;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  categoriaAtiva = cat;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding vertical reduzido
                decoration: BoxDecoration(
                  color: isAtiva ? const Color(0xFF81C784) : Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: isAtiva ? Colors.green.shade800 : Colors.grey.shade400, width: 2),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: Text(
                  cat.toUpperCase(),
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w900,
                    fontSize: 15, // Fonte levemente menor
                    color: isAtiva ? Colors.white : Colors.black54,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // =====================================================================
  // GRID OTIMIZADO: Agora com 4 Colunas!
  // =====================================================================
  Widget _buildGridDeCartas() {
    final cartasDaCategoria = bancoDeCartas[categoriaAtiva] ?? [];

    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // MUDANÇA PRINCIPAL: Agora são 4 colunas!
        childAspectRatio: 1.3, // Deixa a madeira um pouco mais "retangular" para caber tudo
        crossAxisSpacing: 12, // Espaço entre colunas reduzido
        mainAxisSpacing: 12, // Espaço entre linhas reduzido
      ),
      itemCount: cartasDaCategoria.length,
      itemBuilder: (context, index) {
        final carta = cartasDaCategoria[index];
        return _buildCardCatalogo(carta);
      },
    );
  }

  // =====================================================================
  // MOLDE DOS BOTÕES: Ajustado para o novo tamanho menor
  // =====================================================================
  Widget _buildCardCatalogo(Map<String, dynamic> carta) {
    String texto = carta['texto'] ?? '???';
    String emoji = carta['emoji'] ?? '❓';

    return InkWell(
      onTap: () {
        setState(() {
          fraseAtual.add(texto);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/base_card.png'),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(20),
          // Sombra removida como você havia pedido anteriormente
        ),
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // EMOJI: Tamanho reduzido para 35 para caber bem na nova coluna
            Text(
              emoji,
              style: const TextStyle(fontSize: 35),
            ),

            const SizedBox(height: 2),

            // TEXTO: Tamanho reduzido para 15
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                texto.toUpperCase(),
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}