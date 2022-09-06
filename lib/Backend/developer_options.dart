import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:brain_app/Backend/brain_debug.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/brain_toast.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DeveloperOptions{
  static bool videoPlaying = false;
  static List<String> activatedCodes = ["onscreenlogging","logsaves", "savelogs"];

  static Map<String,List<dynamic>> codes = {
    "fortnite" : [Fortnite, "Fortnite Gaming", "Macht Fortnite"],
    "sharkswimmingocean" : [SharkSwimmingOcean, "Shark Swimming Ocean", "Der Hai der schwimmt"],
    "manuel" : [Manuel, "Manuel", "Manuel hat das gemacht 🥳 🥳 "],
    "sebastian" : [Sebastian, "Sebastian", "Sebastian hat das gemacht"],
    "ninja" : [Ninja, "Ninja", "Macht alles Unsichtbar"],
    "dunkelheit" : [Dunkelheit, "Dunkelheit", "Macht alles Schwarz"],
    "krebs" : [Cancer, "Schöner Modus", "Macht alles sehr schön :)"],
    "felix" : [Doenerladen, "Felix", "Dieser Code basiert auf einem unserer sehr guten wenn nicht sogar besten Freunde namens Felix `Habhax` Leopold Drescher dieser dieses Lied Komponierter"
        " um ihn zu ehren und um seinen tode an extremer fettsucht zu betraueren ist dieses lied hinzugefügt worden. " ],
    "test" : [Test,"Test","Wenn man mal was testen muss"],
    "onscreenlogging" : [onScreenLogging,"On Screen Logging", "Zeigt alle Logs auf dem Bildschirm an"],
    "logsaves" : [logSaves, "Log Saves", "onScreenLogging sollte aktiviert sein"],
    "savelogs" : [saveLogs, "Save Logs", "Speichert alle Logs ACHTUNG: VERBRAUCHT VIEL SPEICHER"],
    "habhax" : [HabHax, "HabHax", "Schaut euch das populäre Fortnite playthrough des berühmten Youtubers HabHax in der Übersicht an!"]
  };


  static void enterText(String? text){
    if(text == "" || text == null) return;
    String convertedText = text.toLowerCase().trim();

    List<dynamic>? result = codes[convertedText];

    if(result != null){
      Function function = result[0] as Function;
      function.call();
      if(!activatedCodes.contains(convertedText)){
        activatedCodes.add(convertedText);
        SaveSystem.saveDeveloperOptions();
      }
      BrainApp.notifier.notifyOfChanges();
    }

    /*
    switch(text.toLowerCase().trim()){
      case "fortnite":
        Fortnite();
        break;
      case "sharkswimmingocean":
        SharkSwimmingOcean();
        break;
      case  "manuel":
        Manuel();
        break;
      case "sebastian":
        Sebastian();
        break;
      case "ninja":
        Ninja();
        break;
      case "dunkelheit":
        Dunkelheit();
        break;
      case "krebs":
        Cancer();
        break;
      default:
        return;
    }
    */


  }

  static void HabHax() {
    videoPlaying = true;
    BrainApp.notifier.notifyOfChanges();
  }

  static Widget getVideoPlayer() {
    YoutubePlayerController videoController = YoutubePlayerController(
      initialVideoId: 'MRonk2k6-ac',
      flags: const YoutubePlayerFlags(
          loop: true,
          enableCaption: false,
          hideControls: true,
          disableDragSeek: true,
          autoPlay: true
      ),
    );

    return Container(
      color: AppDesign.colors.primary,
      padding: const EdgeInsets.all(10),
      child: YoutubePlayer(
        controller: videoController,
        showVideoProgressIndicator: true,
        progressColors: const ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
      ),
    );
  }

  static void Ninja() {
    AppDesign.setFromPackage(BlindnessDesign().darkVariant);
  }

  static void Dunkelheit() {
    AppDesign.setFromPackage(BlindnessDesign().lightVariant);

  }

  static void Doenerladen() {
    AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.play(AssetSource("../data/notification_sounds.mp3"), volume: 0.9);
  }

  static void Fortnite(){

  }

  static void Cancer() async{
    Timer.periodic(const Duration(seconds: 1), (timer) {
      AppDesign.setFromPackage(CancerDesign().darkVariant);
    });
    await Future.delayed(const Duration(milliseconds: 500));
    Timer.periodic(const Duration(seconds: 1), (timer) {
      AppDesign.setFromPackage(CancerDesign().lightVariant);
    });



  }



  static void SharkSwimmingOcean(){
    NavigationHelper.rootKey.currentState!.pushNamed("imagePage", arguments: "images/Rendered SSO.jpg");
  }

  static void Manuel() {
    Doenerladen();
    showDialog(
      context: NavigationHelper.rootKey.currentContext!,
      builder: (context) {
        return Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: Image.asset(
                      "images/sparkle.gif",
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.cover,
                    )
                  ),
                  Positioned(
                      top: 0,
                      left: MediaQuery.of(context).size.width / 2 - 75,
                      child: Image.asset("images/party.gif", width: 150)
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2 - 150,
                    bottom: 50,
                    child: RotatingImage(
                        order: MatrixOrder.xyz,
                        image: Image.asset("images/Rendered SSO.jpg", width: 150)
                    )
                  ),
                  Positioned(
                      left: MediaQuery.of(context).size.width / 2,
                      bottom: 150,
                      child: RotatingImage(
                          order: MatrixOrder.yzx,
                          image: Image.asset("images/Rendered SSO.jpg", width: 150)
                      )
                  ),
                  Positioned(
                      left: MediaQuery.of(context).size.width / 2 - 150,
                      bottom: 250,
                      child: RotatingImage(
                          order: MatrixOrder.zxy,
                          image: Image.asset("images/Rendered SSO.jpg", width: 150)
                      )
                  )
                ]
              )
            )
          ]
        );
      }
    );
  }

  static void Test(){


  }

  static void onScreenLogging(){
    BrainApp.updatePreference("showLogsOnScreen", !BrainApp.preferences["showLogsOnScreen"]);
    BrainToast(text: "on screen logging is now ${BrainApp.preferences["showLogsOnScreen"]}").show();

  }

  static void logSaves(){
    LocalStorage ls =  LocalStorage("brain_app");

    StreamSubscription ss =  ls.stream.listen((event) {},);
    ss.onData((event) {
      event.forEach((key, value)
      {BrainDebug.log("$key, $value");
      });
      ss.cancel();
    });

    BrainApp.preferences.forEach((key, value) {
      BrainDebug.log("$key, $value");
    });


  }

  static void saveLogs(){
    BrainApp.updatePreference("saveLogs", !BrainApp.preferences["saveLogs"]);
    BrainToast(text: "log saving is now ${BrainApp.preferences["saveLogs"]}").show();
  }

  static void Sebastian(){

    TimeTable.saveEnabled = false;

    Subject("n",Colors.pink);
    Subject("a",Colors.pink);
    Subject("i",Colors.pink);
    Subject("t",Colors.pink);
    Subject("s",Colors.pink);
    Subject("a",Colors.pink);
    Subject("b",Colors.pink);
    Subject("e",Colors.pink);
    Subject("S",Colors.pink);

    for(int day = 1; day <= 5; day++){
      for(int lesson = 0; lesson < 9; lesson++){
        SubjectInstance(TimeTable.subjects[TimeTable.subjects.length - (lesson + 1)], day,lesson) ;
      }

    }


    for(Subject subject in TimeTable.subjects){
      DateTime? time = subject.getNextDate();
      if(time != null){
        if(time.year == DateTime.now().year && time.month == DateTime.now().month && time.day == DateTime.now().day){
          time = time.add(const Duration(days: 7));
        }
        Homework(subject,time,"instagram: @sesegamer,twitter.com/cockman59627141,youtube: UwUGaming");
      }
    }

    TimeTable.saveEnabled = true;
    for(int i = 0; i < 100; i++){
      Event(DateTime(2005 + i,3,12),"Sebastian Geburtstag", "Er wird heute $i Jahre Alt");

    }
    Event(DateTime(2005 + 100,3,12),"Sebastian Geburtstag", "Er wird heute sterben");


    BrainApp.notifier.notifyOfChanges();


  }

}

enum MatrixOrder {
  xyz,
  yzx,
  zxy
}

class RotatingImage extends StatefulWidget {
  const RotatingImage({
    super.key,
    required this.image,
    required this.order
  });

  final Widget image;
  final MatrixOrder order;

  @override
  State<StatefulWidget> createState() => _RotatingImage();
}

class _RotatingImage extends State<RotatingImage> with SingleTickerProviderStateMixin {
  late AnimationController animationController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late Animation<double> rotateY;

  @override
  void initState() {
    animationController.repeat();
    rotateY = Tween<double>(
      begin: 0,
      end: 2,
    ).animate(animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        Matrix4 matrix;
        switch (widget.order) {
          case MatrixOrder.xyz:
            matrix = Matrix4.rotationX(rotateY.value * pi)
              ..multiply(Matrix4.rotationY(rotateY.value * pi))
              ..multiply(Matrix4.rotationZ(rotateY.value * pi));
            break;
          case MatrixOrder.yzx:
            matrix = Matrix4.rotationY(rotateY.value * pi)
              ..multiply(Matrix4.rotationZ(rotateY.value * pi))
              ..multiply(Matrix4.rotationX(rotateY.value * pi));
            break;
          case MatrixOrder.zxy:
            matrix = Matrix4.rotationZ(rotateY.value * pi)
              ..multiply(Matrix4.rotationX(rotateY.value * pi))
              ..multiply(Matrix4.rotationY(rotateY.value * pi));
            break;
        }

        return Transform(
          alignment: FractionalOffset.centerLeft,
          transform: matrix,
          child: widget.image,
        );
      },
    );
  }
}