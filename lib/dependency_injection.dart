import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pharmcare/network_controller.dart';

class Dpenedency_injection{
  static void init(){
    Get.put<Network_controller>(Network_controller(),permanent:true);
  }
}