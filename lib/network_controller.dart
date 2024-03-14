import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkController extends GetxController {
  final InternetConnectionChecker _connectionChecker =
      InternetConnectionChecker();
  bool _hasConnection = true;

  bool get hasConnection => _hasConnection;

  @override
  void onInit() {
    super.onInit();
    _connectionChecker.onStatusChange.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(InternetConnectionStatus status) {
    final bool wasConnected = _hasConnection;
    _hasConnection = status != InternetConnectionStatus.disconnected;
    update();

    if (status == InternetConnectionStatus.disconnected) {
      Get.rawSnackbar(
        messageText: const Text('Please check internet connection'),
        isDismissible: false,
        duration: const Duration(days: 1),
        backgroundColor: Colors.red,
        icon: const Icon(Icons.wifi_off, color: Colors.white, size: 35),
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.GROUNDED,
      );
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }


}
