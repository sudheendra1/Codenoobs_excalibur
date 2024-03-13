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
    if (!wasConnected && _hasConnection) {
      _showReloadPrompt(); // Show reload prompt when connection is reestablished
    }
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

  void _showReloadPrompt() {
    // Show a dialog or a snackbar to notify the user about the reconnection
    // Provide an option to reload the app
    // Example: show a snackbar with a reload button
    Get.snackbar(
      'Internet Connection Restored',
      'You are now connected to the internet. Do you want to reload the app?',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(days: 1),
      mainButton: TextButton(
        onPressed: () {
          Get.offAll(Get.currentRoute); // Reload the app
        },
        child: Text('Reload'),
      ),
    );
  }
}
