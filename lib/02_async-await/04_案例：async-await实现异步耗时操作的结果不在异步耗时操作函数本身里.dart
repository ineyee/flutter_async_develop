import 'dart:async';

import 'package:flutter/material.dart';

class AsyncAwaitMultiWidget extends StatefulWidget {
  const AsyncAwaitMultiWidget({Key? key}) : super(key: key);

  @override
  State<AsyncAwaitMultiWidget> createState() => _AsyncAwaitMultiWidgetState();
}

/*
  这个案例模拟的就是“异步耗时操作的结果不是在异步耗时操作函数本身里就能拿到的，而是在其它地方才能拿到，比如蓝牙通信”的场景

  只能用半async-await
  因为在异步耗时操作函数定义阶段我们根本await不到成功的数据、也捕获不到失败的错误，因为异步耗时操作的结果压根不在异步耗时操作函数，而是在其它地方
  所以只能在异步耗时操作函数调用阶段用一下async-await了
 */
class _AsyncAwaitMultiWidgetState extends State<AsyncAwaitMultiWidget> {
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
    Timer(const Duration(milliseconds: 5000), () {
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

  Future<void> exeEnv1() async {
    try {
      final value = await getDeviceBattery();
      debugPrint("===>获取电量成功：$value");
    } catch (error) {
      debugPrint("===>获取电量失败：$error");
    }
  }

  Future<void> exeEnv2() async {
    try {
      final value = await getDeviceMacAddress();
      debugPrint("===>获取Mac地址成功：$value");
    } catch (error) {
      debugPrint("===>获取Mac地址失败：$error");
    }
  }

  Future<void> exeEnv3() async {
    try {
      final value = await getDeviceFirmware();
      debugPrint("===>获取固件版本成功：$value");
    } catch (error) {
      debugPrint("===>获取固件版本失败：$error");
    }
  }

  @override
  void initState() {
    super.initState();

    // 监听
    _listenDeviceResponse();

    // 请求
    exeEnv1();
    exeEnv2();
    exeEnv3();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
