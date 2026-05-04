import 'package:flutter/material.dart';

class ComecarScreen extends StatefulWidget {
  // Criei a variável que vai guardar se é menino ou menina
  final String genero;

  // 2. Obriguei a tela a receber essa informação quando for aberta
  const ComecarScreen({super.key, required this.genero});

  @override
  State<ComecarScreen> createState() => _ComecarScreenState();
}

class _ComecarScreenState extends State<ComecarScreen> {
  // Essa lista guarda as palavras que a criança clica
  List<String> fraseAtual = [];

  //  Nossa base de dados temporária (depois trocaremos por imagens e pastas)
  final List<String> cardsExemplo = [
    'Eu quero', 'Comer', 'Beber', 'Brincar',
    'Banheiro', 'Dormir', 'Sim', 'Não'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Um fundo com cor bem leve e calmante para focar nos cards
      backgroundColor: const Color(0xFFE0F2F1),

      appBar: AppBar(
        title: const Text('Montar Frase', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87), // A setinha de voltar automática!
        actions: [
          // Botão de Apagar o último card
          IconButton(
            icon: const Icon(Icons.backspace, color: Colors.redAccent, size: 32),
            onPressed: () {
              setState(() {
                if (fraseAtual.isNotEmpty) {
                  fraseAtual.removeLast(); // Remove a última palavra da lista
                }
              });
            },
          ),
          const SizedBox(width: 16),

          // Botão de Falar (Text-to-Speech que faremos no futuro)
          IconButton(
            icon: const Icon(Icons.record_voice_over, color: Colors.green, size: 36),
            onPressed: () {
              // Aqui vai entrar o pacote de voz em breve!
            },
          ),
          const SizedBox(width: 16),
        ],
      ),

      body: Column(
        children: [
          // ÁREA 1: A LOUSA (Onde os cards selecionados aparecem)
          Container(
            height: 120,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black12, width: 2),
            ),
            child: fraseAtual.isEmpty
                ? const Center(
              child: Text(
                'Toque nos botões abaixo para formar uma frase...',
                style: TextStyle(fontSize: 24, color: Colors.black38),
              ),
            )
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              itemCount: fraseAtual.length,
              itemBuilder: (context, index) {
                return _buildCardLousa(fraseAtual[index]);
              },
            ),
          ),

          // ÁREA 2: O CATÁLOGO DE CARDS (A grade com as opções)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 colunas para caber bem na tela deitada
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5, // Deixa os botões um pouco mais largos
                ),
                itemCount: cardsExemplo.length,
                itemBuilder: (context, index) {
                  return _buildCardCatalogo(cardsExemplo[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Molde visual para os botões grandes de escolher
  Widget _buildCardCatalogo(String texto) {
    return InkWell(
      onTap: () {
        // O setState avisa o Flutter: "A lista mudou, desenhe a tela de novo!"
        setState(() {
          fraseAtual.add(texto);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF4C8A1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black54, width: 2),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2))],
        ),
        child: Center(
          child: Text(
            texto,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // Molde visual para os cards pequenos que ficam lá em cima na lousa
  Widget _buildCardLousa(String texto) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        texto,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
      ),
    );
  }
}