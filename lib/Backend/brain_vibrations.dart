import 'package:vibration/vibration.dart';

import '../main.dart';

class BrainVibrations{
  static bool canVibrate = false;
  static bool hasCustom = false;
  static bool hasAmplitude = false;

  static void init() async{
   if(await Vibration.hasVibrator() != null) canVibrate = (await Vibration.hasVibrator())!;
   if(await Vibration.hasAmplitudeControl() != null) hasAmplitude = (await Vibration.hasAmplitudeControl())!;
   if(await Vibration.hasCustomVibrationsSupport() != null) hasCustom = (await Vibration.hasCustomVibrationsSupport())!;
  }

  static void defaultVibrate(){
    if(canVibrate && BrainApp.preferences["vibration"]) Vibration.vibrate();
  }

  static void successVibrate(){
    if(!BrainApp.preferences["vibration"])return;
    if(!canVibrate)return;
    if(!hasCustom ||!hasAmplitude) {
      defaultVibrate();
    } else {
      Vibration.vibrate(duration: 150,amplitude: 40 );
    }
  }

  static void errorVibrate() async{
    if(!BrainApp.preferences["vibration"])return;
    if(!canVibrate)return;
    if(!hasCustom ||!hasAmplitude) {
      defaultVibrate();
      await Future.delayed(const Duration(milliseconds: 500));
      Vibration.vibrate();
    } else {
      Vibration.vibrate(duration: 400,amplitude: 70 );
    }
  }


}