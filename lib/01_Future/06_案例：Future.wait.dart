import 'dart:async';

import 'package:flutter/material.dart';

class FutureWaitWidget extends StatefulWidget {
  const FutureWaitWidget({Key? key}) : super(key: key);

  @override
  State<FutureWaitWidget> createState() => _FutureWaitWidgetState();
}

/*
  实际开发中，有时我们可能希望多个异步耗时操作都有结果了，我们再统一做成功的处理，而一旦其中任意一个异步耗时操作失败了，我们就视作失败

  比如在蓝牙通信中，我们在获取设备信息时，希望获取设备电量、获取设备Mac地址、获取设备固件版本都成功了，我们才视作真正蓝牙连接成功，而一旦其中任意一个信息没获取到，我们就视作蓝牙连接失败

  此时就可以用Future.wait来非常爽地实现这个需求
 */
class _FutureWaitWidgetState extends State<FutureWaitWidget> {
  // 记录所有的Completer对象
  final String _getDeviceBatteryCompleterKey = "260101";
  final String _getDeviceMacAddressCompleterKey = "260202";
  final String _getDeviceFirmwareCompleterKey = "260303";
  final Map<String, Completer> _completerMap = {};

  Future<int> getDeviceBattery() {
    final Completer completer = Completer<int>();
    _completerMap[_getDeviceBatteryCompleterKey] = completer;

    // 2s超时
    Timer(const Duration(milliseconds: 2000), () {
      if (completer.isCompleted == false) {
        completer.completeError("获取电量超时...");
      }
    });

    return completer.future as Future<int>;
  }

  Future<String> getDeviceMacAddress() {
    final Completer completer = Completer<String>();
    _completerMap[_getDeviceMacAddressCompleterKey] = completer;

    // 2s超时
    Timer(const Duration(milliseconds: 2000), () {
      if (completer.isCompleted == false) {
        completer.completeError("获取Mac地址超时...");
      }
    });

    return completer.future as Future<String>;
  }

  Future<double> getDeviceFirmware() {
    final Completer completer = Completer<double>();
    _completerMap[_getDeviceFirmwareCompleterKey] = completer;

    // 2s超时
    Timer(const Duration(milliseconds: 2000), () {
      if (completer.isCompleted == false) {
        completer.completeError("获取固件版本超时...");
      }
    });

    return completer.future as Future<double>;
  }

  // 无论App给蓝牙设备发送多少条指令
  // 蓝牙设备给App的响应都是在同一个回调里，这个函数就是模拟那个监听回调
  void _listenDeviceResponse() {
    // 假设1.5s后收到了获取电量的响应
    Timer(const Duration(milliseconds: 1500), () {
      // 那这里得拿到获取电量那个Completer对象来调用complete
      Completer completer = _completerMap[_getDeviceBatteryCompleterKey]!;
      if (completer.isCompleted == false) {
        // 成功时
        completer.complete(80);
        // 失败时
        // completer.completeError("正在充电，无法获取...");
      }
    });

    // 假设1s后收到了获取Mac地址的响应
    Timer(const Duration(milliseconds: 1000), () {
      // 那这里得拿到获取Mac地址那个Completer对象来调用complete
      Completer completer = _completerMap[_getDeviceMacAddressCompleterKey]!;
      if (completer.isCompleted == false) {
        // 成功时
        completer.complete("AA:BB:CC:DD:EE:FF");
        // 失败时
        // completer.completeError("读取Mac地址出错");
      }
    });

    // 假设5s后收到了获取固件版本的响应
    Timer(const Duration(milliseconds: 2000), () {
      // 那这里得拿到获取固件版本那个Completer对象来调用complete
      Completer completer = _completerMap[_getDeviceFirmwareCompleterKey]!;
      if (completer.isCompleted == false) {
        // 成功时
        completer.complete(0.9);
        // 失败时
        // completer.completeError("读取固件版本出错");
      }
    });
  }

  // 这个异步耗时操作函数里Future.wait这个异步耗时操作本身就返回一个Future
  Future<List<dynamic>> getAllDeviceInfo() {
    Completer completer = Completer<List<dynamic>>();

    Future future1 = getDeviceBattery();
    Future future2 = getDeviceMacAddress();
    Future future3 = getDeviceFirmware();
    /*
      Future.wait接收一个数组作为参数，数组里就是我们想打包在一起的所有小Future对象
      Future.wait本身的返回值也是一个Future、这里我们称之为大Future对象，我们就是通过这个大Future对象的then方法来监听所有小Future的结果的

      当所有小Future对象都走complete上报时，就会触发大Future对象then的第一个函数————即成功，且参数是一个数组————里面存放着所有小Future对象complete上来的数据，数据的顺序跟[future1, future2, future3]的顺序一样
      而当任意一个小Future对象走了completeError上报时，就会立即停止其它小Future对象的任务，并触发大Future对象then的第二个函数————即失败，且参数不是数组、就是失败的那个小Future对象completeError上来的数据
    */
    Future.wait([future1, future2, future3]).then(
      (valueList) {
        debugPrint("===>蓝牙连接成功：$valueList");
        debugPrint("===>电量：${valueList[0]}");
        debugPrint("===>Mac地址：${valueList[1]}");
        debugPrint("===>固件版本：${valueList[2]}");
        if (completer.isCompleted == false) {
          completer.complete(valueList);
        }
      },
      onError: (error) {
        debugPrint("===>蓝牙连接失败：$error");
        if (completer.isCompleted == false) {
          completer.completeError(error);
        }
      },
    );

    return completer.future as Future<List<dynamic>>;
  }

  @override
  void initState() {
    super.initState();

    // 监听
    _listenDeviceResponse();

    // 请求
    getAllDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
