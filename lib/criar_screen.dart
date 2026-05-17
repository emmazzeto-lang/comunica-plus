import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_appbar.dart';

class CriarScreen extends StatefulWidget {
  const CriarScreen({super.key});

  @override
  State<CriarScreen> createState() => _CriarScreenState();
}

class _CriarScreenState extends State<CriarScreen> {
  final TextEditingController _textoController = TextEditingController();
  final TextEditingController _emojiController = TextEditingController();

  final List<String> categoriasDisponiveis = ["Pessoas", "Comida", "Ações", "Sentimentos", "Objetos"];
  String _categoriaSelecionada = "Comida";

  List<Map<String, dynamic>> _cartasCustomizadas = [];
  int? _indiceEditando;

  @override
  void initState() {
    super.initState();
    _carregarCartasSalvas();
  }

  @override
  void dispose() {
    _textoController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  // =====================================================================
  // LÓGICA DE BANCO DE DADOS
  // =====================================================================
  Future<void> _carregarCartasSalvas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartasJson = prefs.getString('cartas_customizadas');

    if (cartasJson != null) {
      List<dynamic> decodificado = jsonDecode(cartasJson);
      setState(() {
        _cartasCustomizadas = List<Map<String, dynamic>>.from(decodificado);
      });
    }
  }

  Future<void> _salvarNoBanco() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String codificado = jsonEncode(_cartasCustomizadas);
    await prefs.setString('cartas_customizadas', codificado);
  }

  void _salvarCarta() {
    if (_textoController.text.trim().isEmpty || _emojiController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o nome e coloque um emoji!', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.redAccent),
      );
      return;
    }

    final novaCarta = {
      "texto": _textoController.text.trim(),
      "emoji": _emojiController.text.trim(),
      "categoria": _categoriaSelecionada,
      "customizada": true,
    };

    setState(() {
      if (_indiceEditando != null) {
        _cartasCustomizadas[_indiceEditando!] = novaCarta;
        _indiceEditando = null;
      } else {
        _cartasCustomizadas.add(novaCarta);
      }
      _textoController.clear();
      _emojiController.clear();
    });

    _salvarNoBanco();
    FocusScope.of(context).unfocus(); // Fecha o teclado
  }

  void _editarCarta(int index) {
    setState(() {
      _indiceEditando = index;
      _textoController.text = _cartasCustomizadas[index]['texto'];
      _emojiController.text = _cartasCustomizadas[index]['emoji'];
      _categoriaSelecionada = _cartasCustomizadas[index]['categoria'];
    });
  }

  void _removerCarta(int index) {
    setState(() {
      _cartasCustomizadas.removeAt(index);
    });
    _salvarNoBanco();
  }

  // =====================================================================
  // DESIGN DA TELA
  // =====================================================================
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
          titulo: "CRIAR CARTAS",
          corFundo: Color(0xFFE0F2F1),
          corTexto: Color(0xFF00695C),
        ),
        // O SingleChildScrollView resolve o problema do teclado vazando na tela!
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildFormularioDeCriacao(),
                const SizedBox(height: 24),
                _buildSecaoLista(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================================
  // FORMULÁRIO POLIDO
  // =====================================================================
  // =====================================================================
  // FORMULÁRIO POLIDO (Com padding ajustado para não vazar da lousa)
  // =====================================================================
  Widget _buildFormularioDeCriacao() {
    return Container(
      // A MÁGICA ESTÁ AQUI: Aumentamos o espaço no topo e embaixo
      // para forçar o conteúdo a ficar dentro do desenho da madeira!
      padding: const EdgeInsets.only(top: 35, bottom: 40, left: 40, right: 40),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/lousa_base.png'),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(20),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CATEGORIA
          Text("CATEGORIA", style: GoogleFonts.nunito(fontWeight: FontWeight.w900, color: const Color(0xFF00695C))),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF00695C).withValues(alpha: 0.5), width: 2),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _categoriaSelecionada,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF00695C), size: 30),
                style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black87),
                items: categoriasDisponiveis.map((String cat) {
                  return DropdownMenuItem<String>(
                    value: cat,
                    child: Text(cat.toUpperCase()),
                  );
                }).toList(),
                onChanged: (novoValor) => setState(() => _categoriaSelecionada = novoValor!),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NOME DO CARD
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("NOME DO CARD", style: GoogleFonts.nunito(fontWeight: FontWeight.w900, color: const Color(0xFF00695C))),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _textoController,
                      decoration: InputDecoration(
                        hintText: "Ex: Vovó",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: const Color(0xFF00695C).withValues(alpha: 0.5), width: 2)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF00695C), width: 3)),
                      ),
                      style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // EMOJI
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("EMOJI", style: GoogleFonts.nunito(fontWeight: FontWeight.w900, color: const Color(0xFF00695C))),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _emojiController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 26),
                      decoration: InputDecoration(
                        hintText: "👵",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 14),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: const Color(0xFF00695C).withValues(alpha: 0.5), width: 2)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF00695C), width: 3)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // BOTÃO SALVAR
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: _salvarCarta,
              icon: Icon(_indiceEditando == null ? Icons.add_circle : Icons.save_rounded, color: Colors.white, size: 28),
              label: Text(
                _indiceEditando == null ? "CRIAR CARD" : "SALVAR EDIÇÃO",
                style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white, letterSpacing: 1.5),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF81C784),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          )
        ],
      ),
    );
  }

  // =====================================================================
  // SEÇÃO DA LISTA (Fundo claro para dar legibilidade)
  // =====================================================================
  Widget _buildSecaoLista() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90), // Fundo sólido e limpo!
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00695C), width: 3),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.style, color: Color(0xFF00695C)),
              const SizedBox(width: 8),
              Text(
                "CARTAS CRIADAS",
                style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 20, color: const Color(0xFF00695C)),
              ),
            ],
          ),
          const Divider(color: Colors.black26, thickness: 1.5, height: 24),

          if (_cartasCustomizadas.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "Nenhuma carta criada ainda.\nUse o quadro acima para criar!",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          else
          // shrinkWrap é necessário porque o ListView está dentro de um SingleChildScrollView
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _cartasCustomizadas.length,
              itemBuilder: (context, index) {
                final carta = _cartasCustomizadas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2F1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(carta['emoji'], style: const TextStyle(fontSize: 28)),
                    ),
                    title: Text(
                      carta['texto'].toUpperCase(),
                      style: GoogleFonts.nunito(fontWeight: FontWeight.w900, color: Colors.black87, fontSize: 16),
                    ),
                    subtitle: Text(
                      carta['categoria'].toUpperCase(),
                      style: GoogleFonts.nunito(color: const Color(0xFF00695C), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_rounded, color: Colors.blueAccent),
                          onPressed: () => _editarCarta(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_rounded, color: Colors.redAccent),
                          onPressed: () => _removerCarta(index),
                        ),
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