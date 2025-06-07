import 'package:flutter/material.dart';

void main() {
  runApp(Jogo());
}

class Jogo extends StatelessWidget {
  const Jogo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Jogo 2048', home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: '2048', home: const HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '2048',
              style: TextStyle(
                fontFamily: 'Bungee',
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade800,
              ),
            ),
            const SizedBox(height: 80),

            criarBotaoNivel(context, 4, Colors.indigo.shade300, 'Fácil'),
            criarBotaoNivel(context, 5, Colors.purple.shade300, 'Médio'),
            criarBotaoNivel(context, 6, Colors.deepPurple.shade400, 'Difícil'),
          ],
        ),
      ),
    );
  }

  Widget criarBotaoNivel(
    BuildContext context,
    int gridSize,
    Color cor,
    String nivelTexto,
  ) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          backgroundColor: cor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () => _iniciarJogo(context, gridSize, nivelTexto),
        child: Text(
          nivelTexto,
          style: TextStyle(
            fontSize: 24,
            color: Colors.amber.shade50,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
    );
  }

  void _iniciarJogo(BuildContext context, int gridSize, String nivelTexto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PaginaJogo(gridSize: gridSize, nivelTexto: nivelTexto),
      ),
    );
  }
}

class PaginaJogo extends StatefulWidget {
  final int gridSize;
  final String nivelTexto;

  const PaginaJogo({
    super.key,
    required this.gridSize,
    required this.nivelTexto,
  });

  @override
  State<PaginaJogo> createState() => _PaginaJogoState();
}

class _PaginaJogoState extends State<PaginaJogo> {
  Widget criarBotaoMove(BuildContext context, IconData icone) {
    return Container(
      height: 70,
      width: 70,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.purple.shade200,
        border: Border.all(color: Colors.indigo.shade600, width: 3),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(icone, size: 36, color: Colors.indigo.shade600),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        title: Text(
          widget.nivelTexto,
          style: TextStyle(
            color: Colors.indigo.shade600,
            fontFamily: 'Montserrat.bold',
          ),
        ),
        backgroundColor: Colors.amber.shade50,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade200,
                      border: Border.all(
                        color: Colors.indigo.shade800,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Movimentos: ',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.indigo.shade800,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 80),

            SizedBox(
              height: 500,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.gridSize,
                ),
                itemBuilder:
                    (context, index) => Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade200,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '2',
                          style: TextStyle(
                            color: Color.fromRGBO(57, 73, 171, 1),
                            fontSize: 24,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                      ),
                    ),
                itemCount: widget.gridSize * widget.gridSize,
              ),
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                criarBotaoMove(context, Icons.arrow_back),
                SizedBox(width: 10),
                criarBotaoMove(context, Icons.arrow_forward),
                SizedBox(width: 10),
                criarBotaoMove(context, Icons.arrow_upward),
                SizedBox(width: 10),
                criarBotaoMove(context, Icons.arrow_downward),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
