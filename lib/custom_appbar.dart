import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// O "implements PreferredSizeWidget" avisa o Flutter que isso pode ser usado no lugar de uma AppBar padrão
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final Color corFundo;
  final Color corTexto;

  const CustomAppBar({
    super.key,
    required this.titulo,
    required this.corFundo,
    required this.corTexto,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: corFundo,
      elevation: 0, // Mantém a barra "chapada" sem sombra escura por baixo
      centerTitle: true,

      // BOTÃO DE VOLTAR LIMPO E MAIOR
      leading: Padding(
        // Deixei apenas um recuo na esquerda para não grudar na borda do celular
        padding: const EdgeInsets.only(left: 12.0),
        child: InkWell(
          customBorder: const CircleBorder(), // O efeito de "onda" ao clicar continua redondo
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            'assets/images/botao_voltar.png',
            fit: BoxFit.contain, // Isso garante que a seta ocupe o espaço máximo sem distorcer
          ),
        ),
      ),

      // TÍTULO PADRONIZADO
      title: Text(
        titulo.toUpperCase(), // Transforma automaticamente para maiúsculas (ex: CRÉDITOS)
        style: GoogleFonts.nunito(
          textStyle: TextStyle(
            color: corTexto,
            fontWeight: FontWeight.w900,
            fontSize: 26,
            letterSpacing: 1.5, // Dá um pequeno respiro entre as letras
          ),
        ),
      ),
    );
  }

  // Define a altura padrão da barra superior
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}