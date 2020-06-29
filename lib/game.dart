import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:audioplayers/audio_cache.dart';

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GameState();
}

class _GameState extends State<Game> {
  AudioCache _audioPlayer = AudioCache();
  Timer _gameTimer;
  Timer _botReactTimer;
  bool _isGameStart = false;
  bool _isGameOver = false;
  bool _isTimeOver = false;
  int _score = 0;
  int _life = 3;
  int _time = 5;
  Map _currentWaste = {};
  String _currentBotType = "assets/images/bot-idle.png";
  Color _currentBotTypeColor = Colors.blue.withOpacity(0.65);
  final List _wastes = [
    {
      "image": "baby-bottle",
      "color": Colors.orange.withOpacity(0.65),
    },
    {
      "image": "banana-peel",
      "color": Colors.brown.withOpacity(0.65),
    },
    { 
      "image": "battery",
      "color": Colors.red.withOpacity(0.65),
    },
    { 
      "image": "bucket",
      "color": Colors.grey.withOpacity(0.65),
    },
    { 
      "image": "cd",
      "color": Colors.red.withOpacity(0.65),
    },
    { 
      "image": "chips-wrapper",
      "color": Colors.orange.withOpacity(0.65),
    },
    { 
      "image": "drinking-glass",
      "color": Colors.green.withOpacity(0.65),
    },
    { 
      "image": "food-waste",
      "color": Colors.brown.withOpacity(0.65),
    },
    { 
      "image": "fruit-waste",
      "color": Colors.brown.withOpacity(0.65),
    },
    { 
      "image": "game-controller",
      "color": Colors.red.withOpacity(0.65),
    },
    { 
      "image": "laptop",
      "color": Colors.red.withOpacity(0.65),
    },
    { 
      "image": "lemon-peel",
      "color": Colors.brown.withOpacity(0.65),
    },
    { 
      "image": "light-bulb",
      "color": Colors.red.withOpacity(0.65),
    },
    { 
      "image": "paper",
      "color": Colors.blue.withOpacity(0.65),
    },
    { 
      "image": "paper-crumpled",
      "color": Colors.blue.withOpacity(0.65),
    },
    { 
      "image": "paper-cup",
      "color": Colors.blue.withOpacity(0.65),
    },
    { 
      "image": "phone-1",
      "color": Colors.red.withOpacity(0.65),
    },
    { 
      "image": "phone-2",
      "color": Colors.red.withOpacity(0.65),
    },
    { 
      "image": "plastic-bottle",
      "color": Colors.orange.withOpacity(0.65),
    },
    { 
      "image": "poop",
      "color": Colors.brown.withOpacity(0.65),
    },
    { 
      "image": "screw",
      "color": Colors.grey.withOpacity(0.65),
    },
    { 
      "image": "soda-can",
      "color": Colors.grey.withOpacity(0.65),
    },
    { 
      "image": "soda-bottle",
      "color": Colors.green.withOpacity(0.65),
    },
    { 
      "image": "surgical-mask",
      "color": Colors.blue.withOpacity(0.65),
    },
    { 
      "image": "toilet-paper",
      "color": Colors.blue.withOpacity(0.65),
    },
    { 
      "image": "tupper-ware",
      "color": Colors.orange.withOpacity(0.65),
    },
    { 
      "image": "video-game",
      "color": Colors.red.withOpacity(0.65),
    },
    { 
      "image": "wine-bottle",
      "color": Colors.green.withOpacity(0.65),
    },
    { 
      "image": "watering-can",
      "color": Colors.grey.withOpacity(0.65),
    },
  ];

  void _info() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Feed SegreBot", style: TextStyle(fontFamily: "DestructoBeamBold", fontSize: 17)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/waste-sample.png",
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 15),
                  Image.asset(
                    "assets/images/bot-happy.png",
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 15),
                  Image.asset(
                    "assets/images/recycle-logo.png",
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                height: 170,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Text("SegreBot is a robot that eats waste and practices segregation. It has the ability to change its color to accept a specific type of waste."),
                      SizedBox(height: 10),
                      Text("Game Mechanics:\n• Your task is to feed it with random waste that will appear on your screen with the correct color. It has 3 lives. You feed the wrong type of waste, its life decreases.\n• You are given 5 seconds to feed it. Once you feed it with a correct waste, the time is reset to 5. If you ran out of time it will die."),
                      SizedBox(height: 10),
                      Text("Best of luck, Segregate, and Save the planet!"),
                      SizedBox(height: 10),
                    ],
                  )
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("CLOSE", style: TextStyle(fontFamily: "DestructoBeamBold", fontSize: 17)),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _audioPlayer.play("sounds/button.mp3");
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    _audioPlayer.play("sounds/button.mp3");
  }

  void _startGame() {
    _generateNewWaste();
    _startGameTimer();
    setState(() {
      _isGameStart = true;
      _isGameOver = false;
      _isTimeOver = false;
      _score = 0;
      _life = 3;
      _time = 5;
      _currentBotType = "assets/images/bot-idle.png";
    });
    _audioPlayer.play("sounds/button.mp3");
  }

  void _quit() {
    setState(() {
      _isGameStart = false;
      _isGameOver = false;
      _isTimeOver = false;
      _score = 0;
      _life = 3;
      _time = 5;
      _currentBotType = "assets/images/bot-idle.png";
    });
    _audioPlayer.play("sounds/button.mp3");
  }

  void _generateNewWaste() {
    Random rnd = new Random();
    int rn = rnd.nextInt(_wastes.length);
    setState(() {
      _currentWaste = _wastes[rn];
    });
  }

  _startGameTimer() {
    _gameTimer = new Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_time > 0) {
        setState(() {
          _time = _time - 1;
        });
      } else {
        _gameTimer.cancel();

        setState(() {
          _isTimeOver = true;
          _life = 0;
          _currentBotType = "assets/images/bot-sad.png";
        });

        _botReactTimer = new Timer(const Duration(milliseconds: 700), () {
          setState(() {
            _currentBotType = "assets/images/bot-dead.png";
          });
          _botReactTimer.cancel();
        });

        _audioPlayer.play("sounds/fail.mp3");
      }
    });
  }

  _changeColor(color) {
    setState(() {
      _currentBotTypeColor = color;
    });
    _audioPlayer.play("sounds/button.mp3");
  }

  _checkGameStatus(isAlive) {
    if (isAlive) {
      setState(() {
        _currentBotType = "assets/images/bot-happy.png";
        _score = _score + 1;
        _time = _time + (5 - _time);
      });
      _audioPlayer.play("sounds/success.mp3");
    } else {
      setState(() {
        _currentBotType = "assets/images/bot-sad.png";
        _life = _life - 1;
      });
      _audioPlayer.play("sounds/fail.mp3");
    }

    _botReactTimer = new Timer(const Duration(milliseconds: 700), () {
      if (_life > 0) {
        setState(() {
          _currentBotType = "assets/images/bot-idle.png";
        });
      } else {
        setState(() {
          _currentBotType = "assets/images/bot-dead.png";
          _isGameOver = true;
          _isGameStart = false;
        });
      }
      _botReactTimer.cancel();
    });

    _generateNewWaste();
  }

  @override
  void initState() {
    super.initState();
    _generateNewWaste();
  }

  @override
  void dispose() {
    super.dispose();
    _botReactTimer.cancel();
    _gameTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFA4D7ED),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Feed SegreBot", style: TextStyle(fontFamily: "DestructoBeamBold", fontSize: 30)),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Life: " + _life.toString(), style: TextStyle(fontFamily: "DestructoBeamBold", fontSize: 17)),
                SizedBox(width: 20),
                Text("Score: " + _score.toString(), style: TextStyle(fontFamily: "DestructoBeamBold", fontSize: 17)),
                SizedBox(width: 27),
                Text("Time: " + _time.toString(), style: TextStyle(fontFamily: "DestructoBeamBold", fontSize: 17)),
              ],
            ),
            SizedBox(height: 15),
            (!_isGameStart && !_isGameOver && !_isTimeOver) ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.green,
                      textColor: Colors.white,
                      child: Text("PLAY", style: TextStyle(fontFamily: "DestructoBeamBold", fontSize: 23)),
                      onPressed: _startGame,
                    ),
                    SizedBox(width: 15),
                    RaisedButton(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text("INFO", style: TextStyle(fontFamily: "DestructoBeamBold", fontSize: 23)),
                      onPressed: _info,
                    ),
                  ],
                )
              :
                SizedBox(width: 0),
            _isGameOver || _isTimeOver ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.green,
                      textColor: Colors.white,
                      child: Text("RESTART", style: TextStyle(fontFamily: "DestructoBeamBold", fontSize: 23)),
                      onPressed: _startGame,
                    ),
                    SizedBox(width: 15),
                    RaisedButton(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text("QUIT", style: TextStyle(fontFamily: "DestructoBeamBold", fontSize: 23)),
                      onPressed: _quit,
                    ),
                  ],
                )
              :
                SizedBox(width: 0),
            (_isGameStart && !_isGameOver && !_isTimeOver) ?
                Draggable<Color>(
                  data: _currentBotTypeColor,
                  child: Image.asset(
                    "assets/images/" + _currentWaste["image"] + ".png",
                    width: MediaQuery.of(context).size.width / 5,
                    fit: BoxFit.cover,
                  ),
                  childWhenDragging: Image.asset(
                    "assets/images/" + _currentWaste["image"] + ".png",
                    width: MediaQuery.of(context).size.width / 5,
                    fit: BoxFit.cover,
                    color: Color(0XFFA4D7ED),
                  ),
                  feedback: Image.asset(
                    "assets/images/" + _currentWaste["image"] + ".png",
                    width: MediaQuery.of(context).size.width / 5,
                    fit: BoxFit.cover,
                  ),
                )
              :
                SizedBox(width: 0),
            _isGameOver ?
              Column(
                  children: <Widget>[
                    SizedBox(height: 17),
                    Text("Game Over!", style: TextStyle(fontFamily: "DestructoBeamReg", fontSize: 30))
                  ],
                )
              :
                SizedBox(width: 0),
            (_isTimeOver && !_isGameOver) ?
              Column(
                  children: <Widget>[
                    SizedBox(height: 17),
                    Text("Time Over!", style: TextStyle(fontFamily: "DestructoBeamReg", fontSize: 30))
                  ],
                )
              :
                SizedBox(width: 0),
            //SizedBox(height: MediaQuery.of(context).size.height / 4),
            SizedBox(height: 70),
            Stack(
              children: <Widget>[
                Image.asset(
                  _currentBotType,
                  width: MediaQuery.of(context).size.width / 3,
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  "assets/images/bot-idle.png",
                  color: _currentBotTypeColor,
                  width: MediaQuery.of(context).size.width / 3,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 30.0,
                  right: 0.0,
                  left: 0.0,
                  child: DragTarget<Color>(
                    onWillAccept: (data) {
                      if (!_isGameOver && !_isTimeOver) {
                        setState(() {
                          setState(() {
                            _currentBotType = "assets/images/bot-eat.png";
                          });
                        });
                        if (data == _currentWaste["color"]){
                          return true;
                        } else {
                          return true;
                        }
                      } else {
                        return false;
                      }
                    },
                    onAccept: (data) {
                      if (_currentBotTypeColor == _currentWaste["color"]) {
                        _checkGameStatus(true);
                      } else {
                        _checkGameStatus(false);
                      }
                    },
                    onLeave: (data) {
                      String cbt = "";
                      if (!_isGameOver && !_isTimeOver) {
                        cbt = "assets/images/bot-idle.png";
                      } else {
                        cbt = "assets/images/bot-dead.png";
                      }
                      setState(() {
                        _currentBotType = cbt;
                      });
                    },
                    builder: (context, incoming, rejected) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.0)
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text("Paper", style: TextStyle(fontFamily: "DestructoBeamBold")),
                  onPressed: () => _changeColor(Colors.blue.withOpacity(0.65)),
                ),
                SizedBox(width: 5),
                RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  color: Colors.grey,
                  textColor: Colors.white,
                  child: Text("Metal", style: TextStyle(fontFamily: "DestructoBeamBold")),
                  onPressed: () => _changeColor(Colors.grey.withOpacity(0.65)),
                ),
                SizedBox(width: 5),
                RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  color: Colors.orange,
                  textColor: Colors.white,
                  child: Text("Plastic", style: TextStyle(fontFamily: "DestructoBeamBold")),
                  onPressed: () => _changeColor(Colors.orange.withOpacity(0.65)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("E-Waste", style: TextStyle(fontFamily: "DestructoBeamBold")),
                  onPressed: () => _changeColor(Colors.red.withOpacity(0.65)),
                ),
                SizedBox(width: 5),
                RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  color: Colors.green,
                  textColor: Colors.white,
                  child: Text("Glass", style: TextStyle(fontFamily: "DestructoBeamBold")),
                  onPressed: () => _changeColor(Colors.green.withOpacity(0.65)),
                ),
                SizedBox(width: 5),
                RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  color: Colors.brown,
                  textColor: Colors.white,
                  child: Text("Waste", style: TextStyle(fontFamily: "DestructoBeamBold")),
                  onPressed: () => _changeColor(Colors.brown.withOpacity(0.65)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
