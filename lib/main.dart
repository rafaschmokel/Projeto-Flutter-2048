import 'dart:math';

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

            criarBotaoNivel(context, 4, Colors.indigo.shade300, 'Fácil', 1024),
            criarBotaoNivel(context, 5, Colors.purple.shade300, 'Médio', 2048),
            criarBotaoNivel(
              context,
              6,
              Colors.deepPurple.shade400,
              'Difícil',
              4096,
            ),
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
    int objetivo,
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
        onPressed: () => _iniciarJogo(context, gridSize, nivelTexto, objetivo),
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

  void _iniciarJogo(
    BuildContext context,
    int gridSize,
    String nivelTexto,
    int objetivo,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PaginaJogo(
              gridSize: gridSize,
              nivelTexto: nivelTexto,
              objetivo: objetivo,
            ),
      ),
    );
  }
}

class PaginaJogo extends StatefulWidget {
  final int gridSize;
  final String nivelTexto;
  final int objetivo;

  const PaginaJogo({
    super.key,
    required this.gridSize,
    required this.nivelTexto,
    required this.objetivo,
  });

  @override
  State<PaginaJogo> createState() => _PaginaJogoState();
}

class _PaginaJogoState extends State<PaginaJogo> {
  late List<List<int>> grid;
  int moves = 0;
  bool perdeu = false;
  bool ganhou = false;
  int max = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    grid = List.generate(
      widget.gridSize,
      (_) => List.filled(widget.gridSize, 0),
    );
    addNovoNumero();
    addNovoNumero();
  }

  void addNovoNumero() {
    List<Point<int>> espacosVazios = [];

    for (int i = 0; i < widget.gridSize; i++) {
      for (int j = 0; j < widget.gridSize; j++) {
        if (grid[i][j] == 0) {
          espacosVazios.add(Point(i, j));
        }
      }
    }

    if (espacosVazios.isNotEmpty) {
      Random random = Random();
      Point<int> spot = espacosVazios[random.nextInt(espacosVazios.length)];
      grid[spot.x][spot.y] = 2;
    }
  }

  void moveCima() {
    if (ganhou || perdeu) return;

    bool moved = false;

    for (int j = 0; j < widget.gridSize; j++) {
      for (int i = 1; i < widget.gridSize; i++) {
        if (grid[i][j] != 0) {
          int k = i;
          while (k > 0 && grid[k - 1][j] == 0) {
            grid[k - 1][j] = grid[k][j];
            grid[k][j] = 0;
            k--;
            moved = true;
          }

          if (k > 0 && grid[k - 1][j] == grid[k][j]) {
            grid[k - 1][j] *= 2;
            grid[k][j] = 0;
            moved = true;
            checkVitoria();
          }
        }
      }
    }

    if (moved) {
      setState(() {
        moves++;
        addNovoNumero();
        checkDerrota();
      });
    }
  }

  void moveBaixo() {
    if (ganhou || perdeu) return;

    bool moved = false;

    for (int j = 0; j < widget.gridSize; j++) {
      for (int i = widget.gridSize - 2; i >= 1; i--) {
        if (grid[i][j] != 0) {
          int k = i;
          while (k < widget.gridSize - 1 && grid[k + 1][j] == 0) {
            grid[k + 1][j] = grid[k][j];
            grid[k][j] = 0;
            k++;
            moved = true;
          }

          if (k < widget.gridSize && grid[k + 1][j] == grid[k][j]) {
            grid[k + 1][j] *= 2;
            grid[k][j] = 0;
            moved = true;
            checkVitoria();
          }
        }
      }
    }

    if (moved) {
      setState(() {
        moves++;
        addNovoNumero();
        checkDerrota();
      });
    }
  }

  void moveEsquerda() {
    if (ganhou || perdeu) return;

    bool moved = false;

    for (int i = 0; i < widget.gridSize; i++) {
      for (int j = 1; j < widget.gridSize; j++) {
        if (grid[i][j] != 0) {
          int k = i;
          while (k > 0 && grid[i][k - 1] == 0) {
            grid[i][k - 1] = grid[i][k];
            grid[i][k] = 0;
            k--;
            moved = true;
          }

          if (k > 0 && grid[i][k - 1] == grid[i][k]) {
            grid[i][k - 1] *= 2;
            grid[i][k] = 0;
            moved = true;
            checkVitoria();
          }
        }
      }
    }

    if (moved) {
      setState(() {
        moves++;
        addNovoNumero();
        checkDerrota();
      });
    }
  }

  void moveDireira() {
    if (ganhou || perdeu) return;

    bool moved = false;

    for (int i = 0; i < widget.gridSize; i++) {
      for (int j = 1; j < widget.gridSize; j++) {
        if (grid[i][j] != 0) {
          int k = j;
          while (k > 0 && grid[i][k - 1] == 0) {
            grid[i][k - 1] = grid[i][k];
            grid[i][k] = 0;
            k--;
            moved = true;
          }

          if (k > 0 && grid[i][k - 1] == grid[i][k]) {
            grid[i][k - 1] *= 2;
            grid[i][k] = 0;
            moved = true;
            checkVitoria();
          }
        }
      }
    }

    if (moved) {
      setState(() {
        moves++;
        addNovoNumero();
        checkDerrota();
      });
    }
  }

  void checkVitoria() {}

  void checkDerrota() {}

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
