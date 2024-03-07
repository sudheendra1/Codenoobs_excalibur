import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Network_controller extends GetxController{
  final Connectivity _connectivity= Connectivity();

  @override
  void onInit(){
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateconnectionstatus);
  }
  void _updateconnectionstatus(ConnectivityResult connectivityResult){
    if(connectivityResult==ConnectivityResult.none){
      Get.rawSnackbar(
        messageText: const Text(' please check internet connection'),
        isDismissible: false,
        duration:  const Duration(days:1),
        backgroundColor: Colors.red,
        icon: const Icon(Icons.wifi_off,color:Colors.white,size:35),
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.GROUNDED
      );
    }
    else{
      if(Get.isSnackbarOpen){
        Get.closeCurrentSnackbar();
      }
    }
  }
}