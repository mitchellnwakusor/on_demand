import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetChecker{

  static Future<bool> checkInternet() async {
    bool isDeviceConnected;

    isDeviceConnected = await InternetConnectionChecker().hasConnection;

    return isDeviceConnected;

  }
}