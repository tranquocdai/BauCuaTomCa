import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shake_event/shake_event.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:
          ThemeData(primarySwatch: Colors.blue, backgroundColor: Colors.white),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with ShakeHandler, SingleTickerProviderStateMixin {
  var dice1 = 0;
  var dice2 = 0;
  var dice3 = 0;
  bool hiden = true;
  bool selected = false;
  static AudioCache cache = AudioCache();
  List<String> dices = [
        "1.jpg",
    "2.jpg",
    "3.jpg",
    "4.jpg",
    "5.jpg",
    "6.jpg"
  ];
  @override
  void initState() {
    startListeningShake(
        10); //20 is the default threshold value for the shake event
    super.initState();
  }

  @override
  void dispose() {
    resetShakeListeners();
    super.dispose();
  }

  @override
  shakeEventListener() {
    //DO ACTIONS HERE
    if (selected == false) {
      playLocal();
      dice1 = (new Random().nextInt(6) + 0);
      dice2 = (new Random().nextInt(6) + 0);
      dice3 = (new Random().nextInt(6) + 0);
    }
    return super.shakeEventListener();
  }

  playLocal() async {
    await cache.play('mp3/shakingsound.mp3', mode: PlayerMode.LOW_LATENCY);
  }

  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final dynamic tooltip = key.currentState;
          tooltip.ensureTooltipVisible();
        },
        child: Tooltip(
          key: key,
          child: Icon(Icons.wb_incandescent_outlined),
          message: "Shake your phone to change score of dices",
        ),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 50, bottom: 20),
                child: Text("BẦU CUA TÔM CÁ HƯƠU GÀ",textAlign: TextAlign.center, style: TextStyle(fontSize: 50)),
              ),
              Stack(
                alignment: Alignment.center,
                overflow: Overflow.visible,
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/hop.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  createDice(100, 120, 2, dice1),
                  createDice(158, 110, 4, dice2),
                  createDice(135, 170, 25, dice3),
                  AnimatedPositioned(
                    width: selected ? 220 : 220,
                    height: selected ? 220 : 220,
                    top: selected ? -30 : 50.0,
                    left: selected ? -110 : 50.0,
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn,
                    onEnd: () {
                      setState(() {
                        if (selected)
                          hiden = false;
                        else
                          hiden = true;
                      });
                    },
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/nap.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: 150,
                height: 50,
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Colors.cyan,
                    onPressed: () {
                      setState(() {
                        selected = true;
                      });
                    },
                    child: Text(
                      "open",
                      style: TextStyle(fontSize: 30),
                    )),
              ),
              Container(
                  width: 150,
                  height: 50,
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: Colors.cyan,
                      onPressed: () {
                        setState(() {
                          selected = false;
                          hiden = true;
                        });
                      },
                      child: Text("close", style: TextStyle(fontSize: 30)))),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider getimage(int number, List<String> img) {
    return AssetImage("assets/images/" + img[number]);
  }
  Positioned createDice(double left, double top, double angle,int number){
    return Positioned(
        left: left,
        top: top,
        child: Transform.rotate(
          angle: angle,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                image: getimage(number, dices),
                height: 50,
                width: 50,
              ),
            ),
          ),
        ));
  }
}
