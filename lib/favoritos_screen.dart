import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_appbar.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  final TextEditingController _tituloController = TextEditingController();

  bool _estaCriando = false; // Controla se mostra a lista ou o montador
  String categoriaAtiva = "Pessoas";
  final List<String> categorias = ["Pessoas", "Comida", "Ações", "Sentimentos", "Objetos"];

  List<Map<String, dynamic>> _frasesFavoritas = [];
  List<Map<String, dynamic>> _fraseEmConstrucao = [];
  Map<String, List<Map<String, dynamic>>> cartasDinamicas = {};

  // Banco de dados padrão idêntico ao da tela Começar
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
  };

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  // =====================================================================
  // CARREGAMENTO E MISTURA DE DADOS (Cards + Frases Favoritas)
  // =====================================================================
  Future<void> _carregarDados() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 1. Carrega as frases favoritas salvas
    String? favoritosJson = prefs.getString('frases_favoritas');
    if (favoritosJson != null) {
      List<dynamic> decodificado = jsonDecode(favoritosJson);
      _frasesFavoritas = List<Map<String, dynamic>>.from(decodificado);
    }

    // 2. Carrega e mistura os cards customizados (para poder usar nos favoritos)
    Map<String, List<Map<String, dynamic>>> bancoTemporario = {};
    bancoDeCartas.forEach((chave, valor) {
      bancoTemporario[chave] = List<Map<String, dynamic>>.from(valor);
    });

    String? cartasJson = prefs.getString('cartas_customizadas');
    if (cartasJson != null) {
      List<dynamic> decodificadoCartas = jsonDecode(cartasJson);
      for (var item in decodificadoCartas) {
        String cat = item['categoria'];
        if (bancoTemporario.containsKey(cat)) {
          bancoTemporario[cat]!.add(Map<String, dynamic>.from(item));
        }
      }
    }

    setState(() {
      cartasDinamicas = bancoTemporario;
    });
  }

  Future<void> _salvarFavoritosNoBanco() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String codificado = jsonEncode(_frasesFavoritas);
    await prefs.setString('frases_favoritas', codificado);
  }

  // =====================================================================
  // GERENCIAMENTO DAS FRASES
  // =====================================================================
  void _salvarNovaFraseFavorita() {
    String titulo = _tituloController.text.trim();
    if (titulo.isEmpty || _fraseEmConstrucao.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dê um título e selecione pelo menos 1 card!', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.redAccent),
      );
      return;
    }

    final novaFrase = {
      "titulo": titulo,
      "cards": List<Map<String, dynamic>>.from(_fraseEmConstrucao),
    };

    setState(() {
      _frasesFavoritas.add(novaFrase);
      _estaCriando = false;
      _fraseEmConstrucao.clear();
      _tituloController.clear();
    });

    _salvarFavoritosNoBanco();
  }

  void _deletarFraseFavorita(int index) {
    setState(() {
      _frasesFavoritas.removeAt(index);
    });
    _salvarFavoritosNoBanco();
  }

  // =====================================================================
  // INTERFACE PRINCIPAL
  // =====================================================================
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/fundo-especial.jpeg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // Removemos o bloqueio do teclado para ele voltar a aparecer normalmente!
        appBar: const CustomAppBar(
          titulo: "FRASES FAVORITAS",
          corFundo: Color(0xFFE0F2F1),
          corTexto: Color(0xFF00695C),
        ),
        body: SafeArea(
          child: _estaCriando ? _buildMontadorDeFrase() : _buildListaDeFavoritos(),
        ),
      ),
    );
  }

  // VISTA 1: LISTA DE FRASES SALVAS
  Widget _buildListaDeFavoritos() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () => setState(() => _estaCriando = true),
            icon: Image.asset(
            'assets/images/estrela.png', // <-- Atenção: mude para .jpeg ou .jpg se o seu arquivo for diferente!
            width: 28,
            height: 28,),
            label: Text("CRIAR NOVA FRASE FAVORITA", style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF81C784), minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _frasesFavoritas.isEmpty
                ? Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(16)),
                child: Text("Nenhuma frase favorita salva ainda.", textAlign: TextAlign.center, style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54)),
              ),
            )
                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _frasesFavoritas.length,
              itemBuilder: (context, index) {
                final item = _frasesFavoritas[index];
                List<dynamic> cardsDaFrase = item['cards'] ?? [];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF00695C), width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item['titulo'].toString().toUpperCase(), style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 16, color: const Color(0xFF00695C))),
                          IconButton(icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent, size: 28), onPressed: () => _deletarFraseFavorita(index)),
                        ],
                      ),
                      const Divider(height: 8),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: cardsDaFrase.map((card) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: const Color(0xFFE0F2F1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(card['emoji'] ?? '', style: const TextStyle(fontSize: 18)),
                                const SizedBox(width: 4),
                                Text(card['texto'].toString().toUpperCase(), style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // VISTA 2: MONTADOR COMPLETO (Com acesso a todos os cards)
  Widget _buildMontadorDeFrase() {
    final listaCards = cartasDinamicas.isNotEmpty ? cartasDinamicas[categoriaAtiva] ?? [] : bancoDeCartas[categoriaAtiva] ?? [];

    // O SingleChildScrollView aqui garante que a tela role quando o teclado subir
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          // ==========================================
          // LOUSA DE CONSTRUÇÃO
          // ==========================================
          Container(
            // AQUI VOCÊ CONTROLA O VAZAMENTO: Aumente o top ou bottom se o conteúdo encostar na borda da madeira
            padding: const EdgeInsets.only(top: 25, bottom: 30, left: 25, right: 30),
            decoration: BoxDecoration(
              image: const DecorationImage(image: AssetImage('assets/images/lousa_base.png'), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // CAMPO DE TÍTULO
                TextField(
                  controller: _tituloController,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "Título da Frase (Ex: Pedir Lanche)",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: const Color(0xFF00695C).withValues(alpha: 0.5), width: 2)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF00695C), width: 3)),
                  ),
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 14),
                ),
                const SizedBox(height: 12),

                // VISUALIZADOR + BOTÃO DE APAGAR
                Row(
                  children: [
                    // A faixa onde os cards aparecem
                    Expanded(
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(12)),
                        child: _fraseEmConstrucao.isEmpty
                            ? const Center(child: Text("Toque nos cards abaixo...", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 12)))
                            : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _fraseEmConstrucao.length,
                          itemBuilder: (context, idx) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  Text(_fraseEmConstrucao[idx]['emoji'], style: const TextStyle(fontSize: 18)),
                                  const SizedBox(width: 4),
                                  Text(_fraseEmConstrucao[idx]['texto'].toUpperCase(), style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 11)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // BOTÃO VERMELHO DE APAGAR (Novo)
                    if (_fraseEmConstrucao.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _fraseEmConstrucao.removeLast();
                          });
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE57373),
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 2))],
                          ),
                          child: const Icon(Icons.backspace_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 12),

                // BOTÕES DE CANCELAR E SALVAR
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => setState(() { _estaCriando = false; _fraseEmConstrucao.clear(); _tituloController.clear(); }),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade400, minimumSize: const Size(0, 40)),
                        child: const Text("CANCELAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _salvarNovaFraseFavorita,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF81C784), minimumSize: const Size(0, 40)),
                        child: const Text("SALVAR FRASE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ==========================================
          // CATEGORIAS DE CARDS
          // ==========================================
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: categorias.map((cat) {
                bool ativa = categoriaAtiva == cat;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InkWell(
                    onTap: () => setState(() => categoriaAtiva = cat),
                    child: Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: const AssetImage('assets/images/categoria_base.png'), fit: BoxFit.fill, colorFilter: ativa ? null : ColorFilter.mode(Colors.white.withValues(alpha: 0.3), BlendMode.lighten)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(cat.toUpperCase(), style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 13, color: ativa ? const Color(0xFF00695C) : Colors.black87)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // ==========================================
          // PRANCHA / GRID DE CARDS
          // ==========================================
          GridView.builder(
            shrinkWrap: true, // Isso é essencial para o GridView funcionar dentro do SingleChildScrollView
            physics: const NeverScrollableScrollPhysics(), // O scroll agora é feito pela tela toda
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, childAspectRatio: 1.5, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: listaCards.length,
            itemBuilder: (context, index) {
              final card = listaCards[index];
              return InkWell(
                onTap: () => setState(() => _fraseEmConstrucao.add(card)),
                child: Container(
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/base_card.png'), fit: BoxFit.fill)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(card['emoji'], style: const TextStyle(fontSize: 26)),
                      const SizedBox(height: 2),
                      FittedBox(fit: BoxFit.scaleDown, child: Text(card['texto'].toUpperCase(), style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 13))),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}