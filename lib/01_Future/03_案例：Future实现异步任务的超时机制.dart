import 'dart:async';

import 'package:flutter/material.dart';

// Future实现异步任务的超时机制
class FutureTimeoutWidget extends StatefulWidget {
  const FutureTimeoutWidget({Key? key}) : super(key: key);

  @override
  State<FutureTimeoutWidget> createState() => _FutureTimeoutWidgetState();
}

class _FutureTimeoutWidgetState extends State<FutureTimeoutWidget> {
  Future<int> getDeviceBattery() {
    final Completer completer = Completer<int>();

    // 假设获取电量这个操作有时1s就能返回结果，有时则需要5s才能返回结果，延时模拟耗时操作
    // Future.delayed(const Duration(milliseconds: 1000), () {
    //   // 都要做下判断，否则很可能已经走了completeError，再走complete就会报错
    //   if (completer.isCompleted == false) {
    //     completer.complete(80);
    //   }
    // });
    Future.delayed(const Duration(milliseconds: 5000), () {
      // 都要做下判断，否则很可能已经走了completeError，再走complete就会报错
      if (completer.isCompleted == false) {
        completer.complete(80);
      }
    });

    // 但是我们的业务逻辑是2s后如果还拿不到结果就视作超时
    // 所以实际开发中我们就是像下面这么写
    // ① 2s后判断一下completer的状态是否完成了
    // ② 如果完成了自然不会走进if判断里，如果没完成就代表还没拿到结果，我们就判定为超时，直接completeError来结束掉本次completer，告知外界超时，本次异步任务就算是结束了
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (completer.isCompleted == false) {
        completer.completeError("获取电量超时...");
      }
    });

    return completer.future as Future<int>;
  }

  @override
  void initState() {
    super.initState();

    final Future<int> future = getDeviceBattery();
    future.then(
      (value) {
        debugPrint("===>获取电量成功：$value");
      },
      onError: (error) {
        debugPrint("===>获取电量失败：$error");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
