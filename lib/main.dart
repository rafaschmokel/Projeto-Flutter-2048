import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(Jogo());
}

class Jogo extends StatelessWidget {
  const Jogo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Jogo 2048', home: HomePage());
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
    List<List<int>> newGrid = List.generate(
      widget.gridSize,
      (i) => List.from(grid[i]),
    );

    for (int j = 0; j < widget.gridSize; j++) {
      for (int i = 1; i < widget.gridSize; i++) {
        if (newGrid[i][j] != 0) {
          int k = i;
          while (k > 0 && newGrid[k - 1][j] == 0) {
            newGrid[k - 1][j] = newGrid[k][j];
            newGrid[k][j] = 0;
            k--;
            moved = true;
          }

          if (k > 0 && newGrid[k - 1][j] == newGrid[k][j]) {
            newGrid[k - 1][j] *= 2;
            newGrid[k][j] = 0;
            moved = true;
            if (newGrid[k - 1][j] > max) max = newGrid[k - 1][j];
            checkVitoria();
          }
        }
      }
    }

    if (moved) {
      setState(() {
        grid = newGrid;
        moves++;
        addNovoNumero();
        checkDerrota();
      });
    }
  }

  void moveBaixo() {
    if (ganhou || perdeu) return;

    bool moved = false;
    List<List<int>> newGrid = List.generate(
      widget.gridSize,
      (i) => List.from(grid[i]),
    );

    for (int j = 0; j < widget.gridSize; j++) {
      for (int i = widget.gridSize - 2; i >= 0; i--) {
        if (newGrid[i][j] != 0) {
          int k = i;
          while (k < widget.gridSize - 1 && newGrid[k + 1][j] == 0) {
            newGrid[k + 1][j] = newGrid[k][j];
            newGrid[k][j] = 0;
            k++;
            moved = true;
          }

          if (k < widget.gridSize - 1 && newGrid[k + 1][j] == newGrid[k][j]) {
            newGrid[k + 1][j] *= 2;
            newGrid[k][j] = 0;
            moved = true;
            if (newGrid[k + 1][j] > max) max = newGrid[k + 1][j];
            checkVitoria();
          }
        }
      }
    }

    if (moved) {
      setState(() {
        grid = newGrid;
        moves++;
        addNovoNumero();
        checkDerrota();
      });
    }
  }

  void moveEsquerda() {
    if (ganhou || perdeu) return;

    bool moved = false;
    List<List<int>> newGrid = List.generate(
      widget.gridSize,
      (i) => List.from(grid[i]),
    );

    for (int i = 0; i < widget.gridSize; i++) {
      for (int j = 1; j < widget.gridSize; j++) {
        if (newGrid[i][j] != 0) {
          int k = j;
          while (k > 0 && newGrid[i][k - 1] == 0) {
            newGrid[i][k - 1] = newGrid[i][k];
            newGrid[i][k] = 0;
            k--;
            moved = true;
          }

          if (k > 0 && newGrid[i][k - 1] == newGrid[i][k]) {
            newGrid[i][k - 1] *= 2;
            newGrid[i][k] = 0;
            moved = true;
            if (newGrid[i][k - 1] > max) max = newGrid[i][k - 1];
            checkVitoria();
          }
        }
      }
    }

    if (moved) {
      setState(() {
        grid = newGrid;
        moves++;
        addNovoNumero();
        checkDerrota();
      });
    }
  }

  void moveDireita() {
    if (ganhou || perdeu) return;

    bool moved = false;
    List<List<int>> newGrid = List.generate(
      widget.gridSize,
      (i) => List.from(grid[i]),
    );

    for (int i = 0; i < widget.gridSize; i++) {
      for (int j = widget.gridSize - 2; j >= 0; j--) {
        if (newGrid[i][j] != 0) {
          int k = j;
          while (k < widget.gridSize - 1 && newGrid[i][k + 1] == 0) {
            newGrid[i][k + 1] = newGrid[i][k];
            newGrid[i][k] = 0;
            k++;
            moved = true;
          }

          if (k < widget.gridSize - 1 && newGrid[i][k + 1] == newGrid[i][k]) {
            newGrid[i][k + 1] *= 2;
            newGrid[i][k] = 0;
            moved = true;
            if (newGrid[i][k + 1] > max) max = newGrid[i][k + 1];
            checkVitoria();
          }
        }
      }
    }

    if (moved) {
      setState(() {
        grid = newGrid;
        moves++;
        addNovoNumero();
        checkDerrota();
      });
    }
  }

  void checkVitoria() {
    for (int i = 0; i < widget.gridSize; i++) {
      for (int j = 0; j < widget.gridSize; j++) {
        if (grid[i][j] == widget.objetivo) {
          setState(() {
            ganhou = true;
          });
          return;
        }
      }
    }
  }

  void checkDerrota() {
    for (int i = 0; i < widget.gridSize; i++) {
      for (int j = 0; j < widget.gridSize; j++) {
        if (grid[i][j] == 0) return;
      }
    }

    for (int i = 0; i < widget.gridSize; i++) {
      for (int j = 0; j < widget.gridSize; j++) {
        if (i < widget.gridSize - 1 && grid[i][j] == grid[i + 1][j]) {
          return;
        }
        if (j < widget.gridSize - 1 && grid[i][j] == grid[i][j + 1]) {
          return;
        }
      }
    }

    setState(() {
      perdeu = true;
    });
  }

  Color getBotaoCor(int value) {
    if (value == 0) return Colors.deepPurple.shade100;
    if (value == 2) return Colors.amber.shade100;
    if (value == 4) return Colors.amber.shade200;
    if (value == 8) return Colors.amber.shade300;
    if (value == 16) return Colors.amber.shade400;
    if (value == 32) return Colors.amber.shade500;
    if (value == 64) return Colors.amber.shade600;
    if (value == 128) return Colors.amber.shade700;
    if (value == 256) return Colors.amber.shade800;
    if (value == 512) return Colors.amber.shade900;
    if (value == 1024) return Colors.deepOrange.shade400;
    if (value == 2048) return Colors.deepOrange.shade600;
    if (value == 4096) return Colors.red.shade700;
    return Colors.grey;
  }

  Color getTextoCor(int value) {
    return value < 16 ? Colors.deepPurple.shade800 : Colors.white;
  }

  void restart() {
    setState(() {
      moves = 0;
      ganhou = false;
      perdeu = false;
      startGame();
    });
  }

  Widget criarBotaoMove(
    BuildContext context,
    IconData icone,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
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
      ),
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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.indigo.shade600),
            onPressed: restart,
          ),
        ],
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Movimentos: $moves',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.indigo.shade800,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        Text(
                          'Máximo: $max',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.indigo.shade800,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            if (ganhou)
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.deepPurple.shade200,
                child: Text(
                  'PARABÉNS! Você ganhou!',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.amber.shade400,
                    fontFamily: 'Montserrat.bold',
                  ),
                ),
              ),

            if (perdeu)
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.amber.shade200,
                child: Text(
                  'GAME OVER',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.purple.shade400,
                    fontFamily: 'Montserrat.bold',
                  ),
                ),
              ),

            SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.gridSize,
                ),
                itemBuilder: (context, index) {
                  int row = index ~/ widget.gridSize;
                  int col = index % widget.gridSize;
                  int value = grid[row][col];

                  return Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: getBotaoCor(value),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child:
                          value != 0
                              ? Text(
                                value.toString(),
                                style: TextStyle(
                                  fontSize:
                                      value < 100
                                          ? 32
                                          : value < 1000
                                          ? 28
                                          : 24,
                                  color: getTextoCor(value),
                                  fontFamily: 'RobotoCondensed',
                                ),
                              )
                              : SizedBox(),
                    ),
                  );
                },
                itemCount: widget.gridSize * widget.gridSize,
              ),
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                criarBotaoMove(context, Icons.arrow_back, moveEsquerda),
                SizedBox(width: 10),
                criarBotaoMove(context, Icons.arrow_forward, moveDireita),
                SizedBox(width: 10),
                criarBotaoMove(context, Icons.arrow_upward, moveCima),
                SizedBox(width: 10),
                criarBotaoMove(context, Icons.arrow_downward, moveBaixo),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
