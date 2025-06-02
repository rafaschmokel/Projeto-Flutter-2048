import 'package:flutter/material.dart';

void main () {
  runApp (Jogo());
}

class Jogo extends StatelessWidget{

  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Jogo 2048',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo 2048'),
        backgroundColor: Colors.purple.shade200,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          Row(
            children: [
              Expanded(child:
              Container(
                height: 60,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Movimentos: ",
                      style: TextStyle(fontSize: 24),
                )
              )
              )
            ],
          )
        ],
        )
        )
      );
  }
}
