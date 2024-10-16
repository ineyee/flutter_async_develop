import 'dart:io';

import 'package:flutter/material.dart';

// 一、Future之前异步开发的困境
/*
  1、首先回顾下什么是异步任务
  耗时操作：如果一个操作耗时比较长、不是代码执行级别的耗时，那这个操作就是一个耗时操作

  同步任务：我们发起任务后，一直阻塞在那等待耗时操作执行完毕拿结果，那这个任务就是个同步任务
  异步任务：我们发起任务后，不阻塞在那等待耗时操作的执行，而是继续执行其它任务，耗时操作执行完毕后主动把结果告诉我们，那这个任务就是个异步任务。也就是说但凡得等一会儿才能拿到执行结果的任务就是异步任务，比如网络请求、本地I/O操作、蓝牙协议通信等等
 */
class CallbackWidget extends StatefulWidget {
  const CallbackWidget({Key? key}) : super(key: key);

  @override
  State<CallbackWidget> createState() => _CallbackWidgetState();
}

/*
  2、再来回顾下Future之前我们是怎么实现异步开发的——回调函数实现异步开发
  假设我们要实现一个蓝牙协议通信，App向蓝牙设备获取电量信息
 */
class _CallbackWidgetState extends State<CallbackWidget> {
  // 这整个函数是异步任务 = 执行耗时操作 + 通过回调函数上报耗时操作的结果
  void getDeviceBattery(
    void Function(int battery) successCallback,
    void Function(String errorMsg) failureCallback,
  ) {
    // 这里是耗时操作，我们用延时来模拟耗时操作
    sleep(const Duration(milliseconds: 2000));

    // 成功时
    // successCallback(80);
    // 失败时
    failureCallback("正在充电，无法获取...");
  }

  @override
  void initState() {
    super.initState();

    // 发起异步任务
    getDeviceBattery(
      (battery) {
        debugPrint("===>获取电量成功：$battery");
      },
      (errorMsg) {
        debugPrint("===>获取电量失败：$errorMsg");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
/*
  3、回调函数实现异步开发的困境
  很长一段时间内我们都是通过回调函数实现异步开发的，这样做绝对没问题，但是存在弊端：
  * （1）定义异步任务函数————如上面的getDeviceBattery函数————的人很可能只写了success回调函数而没写failure回调函数，又或者failure回调函数写在了success回调函数前面，总之每个人有每个人的风格和习惯，无法统一
  * （2）这就进而导致调用异步任务函数————getDeviceBattery()————的人在使用时得非常小心，甚至得看函数的源码才能知道该怎么传回调函数进去，避免传错

  既然定义和调用异步任务函数这两步会存在不统一的困境，那让这两步统一不就完事了嘛，这就是Future做的事情！
 */
