import 'package:flutter/material.dart';

class TelaInfo extends StatelessWidget {
  const TelaInfo({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,


      appBar: AppBar(
        backgroundColor: const Color(0xFFFAD4E2),
        foregroundColor: const Color(0xFFE32558),
        title: const Text("CRÉDITOS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,

        elevation: 10,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,

        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),

            // ícone dentro do contaner
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),


      //corpo da pagina
      body: Stack(
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



                        const Text("DESENVOLVIMENTO DE SOFTWARE",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF277A5C),
                          ),),


                        //Imagem
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


                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ); // Fecha o Scaffold
  } // Fecha o build
} // Fecha a class