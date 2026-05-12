import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_appbar.dart';

class ConfiguracoesScreen extends StatefulWidget {

  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState()
  => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState
    extends State<ConfiguracoesScreen> {

  String vozSelecionada = 'menino';

  @override
  void initState() {
    super.initState();
    carregarConfiguracao();
  }

  Future<void> carregarConfiguracao() async {

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    setState(() {

      vozSelecionada =
          prefs.getString('voz') ?? 'menino';
    });
  }

  Future<void> salvarConfiguracao(
      String voz) async {

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setString('voz', voz);

    setState(() {

      vozSelecionada = voz;
    });
  }

  Widget cardVoz({

    required String titulo,
    required String imagemPath,
    required Color corBase,
    required Color corTexto,
    required String voz,

  }) {

    bool selecionado =
        vozSelecionada == voz;

    return InkWell(

      onTap: () async {

        await salvarConfiguracao(voz);

        Navigator.pop(context);
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

                color: selecionado
                    ? corBase.withValues(alpha: 0.9)
                    : corBase.withValues(alpha: 0.5),

                borderRadius:
                BorderRadius.circular(40),

                boxShadow: [

                  BoxShadow(
                    color:
                    corBase.withValues(alpha: 0.5),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  )
                ],
              ),

              alignment: Alignment.bottomCenter,

              padding:
              const EdgeInsets.only(bottom: 24),

              child: Text(

                titulo,

                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: corTexto,
                ),
              ),
            ),

            Positioned(
              bottom: 80,

              child: Image.asset(
                imagemPath,
                height: 160,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: const CustomAppBar(

        titulo: 'Configurações',

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

                padding:
                const EdgeInsets.only(top: 20.0),

                child: Row(

                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    cardVoz(

                      titulo: 'Menino',

                      imagemPath:
                      'assets/images/dinossauro.png',

                      corBase:
                      const Color(0xFF81D4FA),

                      corTexto:
                      const Color(0xFF01579B),

                      voz: 'menino',
                    ),

                    const SizedBox(width: 60),

                    cardVoz(

                      titulo: 'Menina',

                      imagemPath:
                      'assets/images/dino-femea.png',

                      corBase:
                      const Color(0xFFF48FB1),

                      corTexto:
                      const Color(0xFF880E4F),

                      voz: 'menina',
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
}