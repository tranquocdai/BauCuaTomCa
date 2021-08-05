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
  bool hiden=true;
  bool selected = false;
  static AudioCache cache = AudioCache();
  List<String> dices = ["dice1.png","dice2.png","dice3.png","dice4.png","dice5.png","dice6.png"];
  @override
  void initState() {
    startListeningShake(10); //20 is the default threshold value for the shake event
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
      dice1 = (new Random().nextInt(5) + 0);
      dice2 = (new Random().nextInt(5) + 0);
    }
    return super.shakeEventListener();
  }
  playLocal() async {
    await cache.play('mp3/shakingsound.mp3',mode: PlayerMode.LOW_LATENCY);
  }
  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
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
                padding: EdgeInsets.only(top: 50,bottom: 20),
                child: Text("DICE GAME",style: TextStyle(fontSize: 50)),
              ),
              Text((hiden==false)?(dice1+dice2+2).toString()+"":"",style: TextStyle(fontSize: 20)),
              Text((hiden==false)?(((dice2+dice1+2)%2==0)?"Even":"Odd"):"",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.red),),
              Stack(
                alignment: Alignment.center,
                overflow: Overflow.visible,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/hop.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                      left: 80,
                      top: 80,
                      child: Container(
                        child: Image(
                          image: getimage(dice1, dices),
                          height: 30,
                          width: 30,
                        ),
                      )),
                  Positioned(
                    left: 105,
                      top: 95,
                      child: Container(
                    child: Image(
                      image: getimage(dice2, dices),
                      height: 30,
                      width: 30,
                    ),
                  )),
                  AnimatedPositioned(
                    width: selected ? 150 : 150,
                    height: selected ? 150 : 150,
                    top: selected ? -1 : 31.0,
                    left: selected ? -70 : 33.0,
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn,
                    onEnd: (){setState(() {
                      if(selected)hiden=false;
                      else hiden=true;
                    });},
                    child: GestureDetector(
                      onTap: () {

                      },
                      child: Container(
                        height: 150,
                        width: 150,
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
                margin: EdgeInsets.only(top: 10,bottom: 10),
                child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    color: Colors.cyan,
                    onPressed: () {
                      setState(() {
                        selected = true;
                      });
                    },
                    child: Text("open",style: TextStyle(fontSize: 30),)),
              ),
              Container(
                width: 150,
                height: 50,
                  margin: EdgeInsets.only(top: 10,bottom: 10),
                child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    color: Colors.cyan,
                    onPressed: () {
                      setState(() {
                        selected = false;
                        hiden=true;
                      });
                    },
                    child: Text("close",style: TextStyle(fontSize: 30)))
              ),

            ],
          ),
        ),
      ),
    );
  }
  ImageProvider getimage(int number,List<String> img){
    return AssetImage("assets/images/"+img[number]);
  }
}
