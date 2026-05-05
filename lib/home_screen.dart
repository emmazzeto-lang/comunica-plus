import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'selecao_perfil_screen.dart';
import 'tela_info.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // CAMADA 1: O FUNDO DA TELA INICIAL
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          // CAMADA 2: O MASCOTE DINOSSAURO (Movido um pouco para a esquerda)
          Positioned(
            right: 50,
            bottom: -10,
            child: Image.asset(
              'assets/images/dinossauro.png',
              height: 400,
              fit: BoxFit.contain,
            ),
          ),

          // CAMADA 3: CONTEÚDO E BOTÕES EM GRADE (2x2)
          SafeArea(
            child: Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // PRIMEIRA LINHA: Começar e Criar
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildMenuButtonImagem(
                              caminhoImagem: 'assets/images/botao_comecar.png',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SelecaoPerfilScreen()),
                                );
                              }
                          ),

                          const SizedBox(width: 16),

                          _buildMenuButtonImagem(
                              caminhoImagem: 'assets/images/botao_criar.png',
                              onPressed: () {}
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // SEGUNDA LINHA: Tutorial e Favoritos
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildMenuButtonImagem(
                              caminhoImagem: 'assets/images/botao_tutorial.png',
                              onPressed: () {}
                          ),

                          const SizedBox(width: 16),

                          _buildMenuButtonImagem(
                              caminhoImagem: 'assets/images/botao_favoritos.png',
                              onPressed: () {}
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),

          // CAMADA 4: O NOVO BOTÃO DE INFORMAÇÕES NO CANTO INFERIOR DIREITO
          Positioned(
            bottom: 0, // Distância do fundo da tela
            right: 0,  // Distância da borda direita
            child: InkWell(
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaInfo()),
                );

              },
              borderRadius: BorderRadius.circular(30), // Efeito de clique arredondado
              child: Image.asset(
                'assets/images/botao_info.png',
                width: 75, // Tamanho menorzinho por ser um botão de canto (pode ajustar)
                fit: BoxFit.contain,
              ),
            ),
          ),

        ],
      ),
    );
  }


  // MOLDE DOS BOTÕES PRINCIPAIS

  Widget _buildMenuButtonImagem({
    required String caminhoImagem,
    required VoidCallback onPressed
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Image.asset(
        caminhoImagem,
        width: 200,
        fit: BoxFit.contain,
      ),
    );
  }
}