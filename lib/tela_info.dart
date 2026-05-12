import 'package:flutter/material.dart';
import 'custom_appbar.dart';

class TelaInfo extends StatelessWidget {
  const TelaInfo({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,


      appBar: const CustomAppBar(
        titulo: "CRÉDITOS",
        corFundo: Color(0xFFE0F2F1),
        corTexto: Color(0xFF00695C),
      ),

      //corpo da pagina
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [

              Positioned.fill(
                child: Image.asset(
                  'assets/images/fundo-especial.jpeg',
                  fit: BoxFit.cover,
                ),
              ),

              //conteudo principal
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),


                      // --- CARD disciplina ---
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [

                            //  imagem
                            Image.asset(
                              'assets/images/info.png',
                              width: 32,
                              height: 32,
                            ),

                            // linha decorativa
                            Container(
                              height: 45,
                              width: 1,
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              color: Colors.grey,
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  // txts
                                  Text.rich(
                                    TextSpan(
                                      children: [

                                        TextSpan(text:'Disciplina: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color(0xFF277A5C))),

                                        TextSpan(text:'Desenvolvimento de Software',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text.rich(
                                    TextSpan(
                                      children: [

                                        TextSpan(text:'Professor: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color(0xFF277A5C))),

                                        TextSpan(text:'Dr. Elvio Gilberto da Silva',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // --- CARD equie ---
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // imagem
                            Image.asset(
                              'assets/images/grupo.png',
                              width: 32,
                              height: 32,
                            ),

                            // linha deco
                            Container(
                              height: 80,
                              width: 1,
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              color: Colors.grey,
                            ),


                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //texto

                                  Text("EQUIPE",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xFF5E33A3))
                                  ),

                                  const SizedBox(height: 6),

                                  Text("• Emerson Mazzeto", style: TextStyle(fontSize: 15, color: Color(0xFF5E33A3))),
                                  Text("• Gabriel de Castro Pettenuci", style: TextStyle(fontSize: 15, color: Color(0xFF5E33A3))),
                                  Text("• Giovanni Gabriel Angélico", style: TextStyle(fontSize: 15, color: Color(0xFF5E33A3))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      //Imagem
                      const Center(
                        child: Text(
                          "DESENVOLVIMENTO DE SOFTWARE",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF277A5C),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/ciencia_da_computacao.jpg',
                              width: 400,
                              height: 150,
                              fit: BoxFit.contain,
                            ),

                            SizedBox(height: 10),

                            Image.asset(
                              'assets/images/coordenadoria-de-extensao.jpg',
                              width: 400,
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ); // Fecha o Scaffold
  } // Fecha o build
} // Fecha a classe