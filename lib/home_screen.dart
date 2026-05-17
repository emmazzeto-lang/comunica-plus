import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'selecao_perfil_screen.dart';
import 'tela_info.dart';
import 'configuracoes_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'comecar_screen.dart';
import 'criar_screen.dart';
import 'favoritos_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> abrirComecar(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Linha de segurança para proteger o app após o 'await'
    if (!context.mounted) return;

    String? voz = prefs.getString('voz');

    if (voz == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SelecaoPerfilScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ComecarScreen(genero: voz),
        ),
      );
    }
  }

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

          // CAMADA 2: O MASCOTE DINOSSAURO
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
                                abrirComecar(context);
                              }
                          ),

                          const SizedBox(width: 16),

                          _buildMenuButtonImagem(
                              caminhoImagem: 'assets/images/botao_criar.png',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const CriarScreen()),
                                );
                              }
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const FavoritosScreen()),
                                );
                              }
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),

          // CAMADA 4: BOTÃO DE CONFIGURAÇÕES (CANTO SUPERIOR DIREITO)
          Positioned(
            // top: 40 garante que o botão não fique escondido atrás do ícone de bateria do celular
            top: 40,
            right: 5,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConfiguracoesScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                'assets/images/botao_config.png',
                width: 70,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // CAMADA 5: BOTÃO DE INFORMAÇÕES (CANTO INFERIOR DIREITO)
          Positioned(
            bottom: 5,
            right: 5,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaInfo(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                'assets/images/botao_info.png',
                width: 75,
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