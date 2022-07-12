
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snakegame/screens/home_scr.dart';
import 'package:snakegame/screens/login_scr.dart';




class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


enum Direction { up, down, left, right }
class _HomePageState extends State<HomePage> {

  List<int> snakePos = [20,20,20];
  int foodLoc = Random().nextInt(300);
  bool start = false;
  Direction direction = Direction.down;
  List<int> totalSpot = List.generate(700, (index) => index); //totalspot
  startGame() {
    start = true;
    snakePos = [20,20,20];
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      updateSnake();
      if (gameOver()) {
        gameOverpopup();
        timer.cancel();
      }
    });
  }

  updateSnake() {
    setState(() {
      switch (direction) {
        case Direction.down:
          if (snakePos.last > 700) {
            snakePos.add(snakePos.last - 700 + 20);
          } else {
            snakePos.add(snakePos.last + 20);
          }
          break;
        case Direction.up:
          if (snakePos.last < 20) {
            snakePos.add(snakePos.last + 700 - 20);
          } else {
            snakePos.add(snakePos.last - 20);
          }
          break;
        case Direction.right:
          if ((snakePos.last + 1) % 20 == 0) {
            snakePos.add(snakePos.last + 1 - 20);
          } else {
            snakePos.add(snakePos.last + 1);
          }
          break;
        case Direction.left:
          if (snakePos.last % 20 == 0) {
            snakePos.add(snakePos.last - 1 + 20);
          } else {
            snakePos.add(snakePos.last - 1);
          }
          break;
        default:
      }
      if (snakePos.last == foodLoc) {
        totalSpot.removeWhere((element) => snakePos.contains(element));

        foodLoc = totalSpot[Random().nextInt(totalSpot.length -
            1)];
      } else {
        snakePos.removeAt(0);
      }
    });
  }

  bool gameOver() {
    final copyList = List.from(snakePos);
    if (snakePos.length > copyList.toSet().length) {
      return true;
    } else {
      return false;
    }
  }

  gameOverpopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content:
          Text('your score is ' + (snakePos.length - 3).toString()),
          actions: [
            TextButton(
                onPressed: () {
                  startGame();
                  Navigator.of(context).pop(true);
                },
                child: const Text('Play Again')),
            TextButton(//exit game
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Exit'))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snake Game',
          style: TextStyle(
            color: Colors.yellowAccent,
          ),),
      ),
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (direction != Direction.up && details.delta.dy > 0) {
              direction = Direction.down;
            }
            if (direction != Direction.down && details.delta.dy < 0) {
              direction = Direction.up;
            }
          },
          onHorizontalDragUpdate: (details) {
            if (direction != Direction.left && details.delta.dx > 0) {
              direction = Direction.right;
            }
            if (direction != Direction.right && details.delta.dx < 0) {
              direction = Direction.left;
            }
          },
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 700,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 20),
            itemBuilder: (context, index) {
              if (snakePos.contains(index)) {
                return Container(
                  color: Colors.greenAccent,
                );
              }
              if (index == foodLoc) {
                return Container(

                  color: Colors.red,
                );
              }
              return Container(
                color: Colors.black,
              );
            },
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(50, 200, 150, 10),
        child: FloatingActionButton(
          onPressed: () {
            startGame();
          },
          child: start
              ? Text((snakePos.length - 3).toString())
              : const Text('Start'),
        ),
      ),
    );
  }
}