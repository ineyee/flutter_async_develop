import 'dart:async';

import 'package:flutter/material.dart';

class CallbackWidget extends StatefulWidget {
  const CallbackWidget({Key? key}) : super(key: key);

  @override
  State<CallbackWidget> createState() => _CallbackWidgetState();
}

// 一、Future之前异步编程的困境
/*
  1、Future之前我们都是通过回调函数来实现异步编程的
 */
class _CallbackWidgetState extends State<CallbackWidget> {
  // 同步函数 + 异步耗时操作 + 回调函数上报和获取异步耗时操作执行完毕的结果
  // ① getDeviceBattery本身是个同步函数，我们把这个函数称为“异步耗时操作函数”，因为定义这个函数的目的就是为了执行它里面的“异步耗时操作”
  void getDeviceBattery(
    void Function(int value) successCallback,
    void Function(String error) failureCallback,
  ) {
    // ② 这里是异步耗时操作，我们用setTimeout来模拟
    Timer(const Duration(milliseconds: 2000), () {
      // ③ 假设2s后，耗时操作执行完毕，通过回调函数来上报结果
      // 成功时
      // successCallback(80);
      // 失败时
      failureCallback("正在充电，无法获取...");
    });
  }

  @override
  void initState() {
    super.initState();

    // ④ 发起异步耗时操作函数，通过回调函数来监听异步耗时操作执行完毕的结果
    getDeviceBattery(
      (value) {
        debugPrint("===>获取电量成功：$value");
      },
      (error) {
        debugPrint("===>获取电量失败：$error");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
/*
  2、通过回调函数实现异步编程的困境
  很长一段时间内我们都是通过回调函数来实现异步编程的，这样做绝对没问题，但是存在弊端：
  * （1）定义异步耗时操作函数————如上面的getDeviceBattery函数————的人很可能只写了success回调函数而没写failure回调函数，又或者failure回调函数写在了success回调函数前面，总之每个人有每个人的风格和习惯，无法统一
  * （2）这就进而导致调用异步耗时操作函数————如上面的getDeviceBattery()————的人在使用时得非常小心，甚至得看函数的源码才能知道该怎么传回调函数进去，避免传错

  既然定义和调用异步耗时操作函数这两步会存在不统一的困境，那让这两步统一不就完事了嘛，这就是Future做的事情！
 */
