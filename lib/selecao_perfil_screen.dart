import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'comecar_screen.dart';
import 'custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelecaoPerfilScreen extends StatelessWidget {
  const SelecaoPerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        titulo: 'Quem vai falar?',
        corFundo: Color(0xFFE0F2F1),
        corTexto: Color(0xFF00695C),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fundo-especial.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCardGenero(
                        context,
                        titulo: 'Menino',
                        imagemPath: 'assets/images/dinossauro.png',
                        corBase: const Color(0xFF81D4FA),
                        corTexto: const Color(0xFF01579B),
                        genero: 'menino'
                    ),

                    const SizedBox(width: 60),

                    _buildCardGenero(
                        context,
                        titulo: 'Menina',
                        imagemPath: 'assets/images/dino-femea.png',
                        corBase: const Color(0xFFF48FB1),
                        corTexto: const Color(0xFF880E4F),
                        genero: 'menina'
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardGenero(BuildContext context, {
    required String titulo,
    required String imagemPath,
    required Color corBase,
    required Color corTexto,
    required String genero
  }) {
    return InkWell(
      onTap: () async {

        SharedPreferences prefs =
        await SharedPreferences.getInstance();

        await prefs.setString(
          'voz',
          genero,
        );

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (context) =>
                ComecarScreen(genero: genero),
          ),
        );
      },
      child: SizedBox(
        width: 260,
        height: 280,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 260,
              height: 220,
              decoration: BoxDecoration(
                color: corBase.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(color: corBase.withValues(alpha: 0.5), blurRadius: 16, offset: const Offset(0, 8))
                ],
              ),
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                titulo,
                style: GoogleFonts.nunito(
                  textStyle: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: corTexto),
                ),
              ),
            ),

            //  DINOSSAUROS "COLADOS" (Ancorados pela base, pertinho do texto)
            Positioned(
              bottom: 80, // A âncora agora é o fundo. 80px deixa ele logo acima das letras!
              child: Image.asset(imagemPath, height: 160),
            ),
          ],
        ),
      ),
    );
  }
}