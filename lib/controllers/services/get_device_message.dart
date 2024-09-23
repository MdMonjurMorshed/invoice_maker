import 'package:flutter/services.dart';

class NormalMethodCall {
  static const MethodChannel channel =
      MethodChannel('com.swad_electric__bill_maker/simpleMethodCall');

  static Future<String> getNormalMethodCallResult() async {
    final String data = await channel.invokeMethod('getNormalMethodCallResult');

    return data;
  }
}
