import 'package:flutter/material.dart';
import 'tela_info.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Pega o tamanho total da tela do aparelho
    final tamanhoTela = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          //Fundo da tela
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          //Conteúdo Principal
          SafeArea(
            child: Row(
              children: [
                //Coluna da Esquerda: Botões (Com proteção extra contra overflow)
                Expanded(
                  flex: 1,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(left: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMenuButton(icon: Icons.volume_up, text: 'Começar', onPressed: () {}),
                          const SizedBox(height: 20),
                          _buildMenuButton(icon: Icons.edit, text: 'Criar', onPressed: () {}),
                          const SizedBox(height: 20),
                          _buildMenuButton(icon: Icons.menu_book, text: 'Tutorial', onPressed: () {}),
                          const SizedBox(height: 20),
                          _buildMenuButton(icon: Icons.star_border, text: 'Favoritos', onPressed: () {}),
                        ],
                      ),
                    ),
                  ),


                // Coluna da Direita: Dinossauro (Deixei ele primeiro porque tive dificuldade nas proporções kk)
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      // Dinossauro colado no chão com Positioned
                      Positioned(
                        bottom: 0,
                        // Centralizei ele um pouco na metade direita da tela
                        right: 40,
                        child: Image.asset(
                          'assets/images/dinossauro.png',
                          height: tamanhoTela.height * 0.90,
                          // Garante que o Flutter puxe os pixels do desenho para baixo
                          alignment: Alignment.bottomCenter,
                        ),
                      ),

                      // Botão de Exclamação (!)
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: FloatingActionButton(
                          mini: true, // Mantém o tamanho mini, ou remova para tamanho padrão

                          // 1. Aqui escolhi a cor do fundo
                          backgroundColor: const Color(0xFFF48FB1),

                          // 2. Aqui escolhi a cor do ícone
                          foregroundColor: Colors.white, // Ícone branco para contraste

                          // 3. Aqui alterei o formato do botão
                          shape: const CircleBorder(), //

                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TelaInfo()),
                            );
                          },
                          child: const Icon(Icons.priority_high), // Ícone de ! (pode mudar se quiser)
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({required IconData icon, required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF4C8A1),
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.black54, width: 2),
        ),
        elevation: 4,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}