import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_appbar.dart';

class TelaInfo extends StatelessWidget {
  const TelaInfo({super.key});

  @override
  Widget build(BuildContext context) {
    // =================================================================
    // MUDANÇA 1: O Container com o fundo agora abraça o Scaffold inteiro.
    // Isso garante que o Scroll nunca mais vai travar!
    // =================================================================
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/fundo-especial.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        // Deixamos o Scaffold invisível para a imagem da parede aparecer
        backgroundColor: Colors.transparent,

        appBar: const CustomAppBar(
          titulo: "CRÉDITOS",
          corFundo: Color(0xFFE0F2F1),
          corTexto: Color(0xFF00695C),
        ),

        body: SafeArea(
          // Agora a lista rolável é a dona absoluta do espaço!
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),

                // =========================================================
                // CARDS LADO A LADO
                // =========================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildCardInfo(
                        icone: 'assets/images/info.png',
                        conteudo: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Disciplina: \n',
                                      style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 16, color: const Color(0xFF277A5C))
                                  ),
                                  TextSpan(
                                      text: 'Desenvolvimento de Software',
                                      style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Professor: \n',
                                      style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 16, color: const Color(0xFF277A5C))
                                  ),
                                  TextSpan(
                                      text: 'Dr. Elvio Gilberto da Silva',
                                      style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(
                      child: _buildCardInfo(
                        icone: 'assets/images/grupo.png',
                        conteudo: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "EQUIPE",
                              style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 16, color: const Color(0xFF5E33A3)),
                            ),
                            const SizedBox(height: 6),
                            Text("• Emerson Mazzeto", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 15, color: const Color(0xFF5E33A3))),
                            Text("• Gabriel de Castro Pettenuci", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 15, color: const Color(0xFF5E33A3))),
                            Text("• Giovanni Gabriel Angélico", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 15, color: const Color(0xFF5E33A3))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // =========================================================
                // MUDANÇA 2: O TEXTO NA CAIXINHA (BADGE) TRANSLÚCIDA
                // =========================================================
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85), // Fundo branquinho e suave
                      borderRadius: BorderRadius.circular(30), // Bordas redondas
                    ),
                    child: Text(
                      "DESENVOLVIMENTO DE SOFTWARE",
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: const Color(0xFF277A5C), // Fica perfeito sobre o branco!
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // IMAGENS LADO A LADO
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/ciencia_da_computacao.jpg',
                      width: 300,
                      height: 100,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(width: 40),

                    Image.asset(
                      'assets/images/coordenadoria-de-extensao.jpg',
                      width: 300,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================================
  // MOLDE DO CARD BRANCO
  // =====================================================================
  Widget _buildCardInfo({required String icone, required Widget conteudo}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(icone, width: 40, height: 40),

          Container(
            height: 80,
            width: 2,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.grey.shade300,
          ),

          Expanded(child: conteudo),
        ],
      ),
    );
  }
}