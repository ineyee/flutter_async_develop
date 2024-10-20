import 'dart:async';

import 'package:flutter/material.dart';

class AsyncAwaitTimeoutWidget extends StatefulWidget {
  const AsyncAwaitTimeoutWidget({Key? key}) : super(key: key);

  @override
  State<AsyncAwaitTimeoutWidget> createState() => _AsyncAwaitTimeoutWidgetState();
}

/*
  这个案例模拟的就是“异步耗时操作本身就是个setTimeout————主要是指超时机制那里的setTimeout、不是指模拟其它异步耗时操作那里的setTimeout”的场景

  只能用半async-await
  因为在异步耗时操作函数定义阶段我们没办法用try catch来捕获setTimeout超时的时机（只能通过setTimeout的回调函数来搞）
  所以只能在异步耗时操作函数调用阶段用一下async-await了
 */
class _AsyncAwaitTimeoutWidgetState extends State<AsyncAwaitTimeoutWidget> {
  Future<int> getDeviceBattery() {
    final Completer completer = Completer<int>();

    // 假设获取电量这个异步耗时操作有时1s就能返回结果，有时则需要5s才能返回结果，我们用setTimeout来模拟
    // Timer(const Duration(milliseconds: 1000), () {
    //   // 都要做下判断，否则很可能已经走了completeError，再走complete就会报错
    //   if (completer.isCompleted == false) {
    //     // 成功时
    //     completer.complete(80);
    //     // 失败时
    //     // completer.completeError("正在充电，无法获取...");
    //   }
    // });
    Timer(const Duration(milliseconds: 5000), () {
      // 都要做下判断，否则很可能已经走了completeError，再走complete就会报错
      if (completer.isCompleted == false) {
        // 成功时
        completer.complete(80);
        // 失败时
        // completer.completeError("正在充电，无法获取...");
      }
    });

    // 异步耗时操作的超时机制都是通过下面这种方式实现的，实际开发中我们就是像下面这么写
    // 2s后直接执行completeError来结束掉本次Future，告知外界超时，本次异步任务就算是结束了
    // ① 2s后判断一下completer的状态是否完成了
    // ② 如果完成了自然不会走进if判断里，如果没完成就代表还没拿到结果，我们就判定为超时
    Timer(const Duration(milliseconds: 2000), () {
      // 都要做下判断，否则很可能已经走了complete，再走completeError就会报错
      if (completer.isCompleted == false) {
        completer.completeError("获取电量超时...");
      }
    });

    return completer.future as Future<int>;
  }

  Future<void> exeEnv() async {
    try {
      final value = await getDeviceBattery();
      debugPrint("===>获取电量成功：$value");
    } catch (error) {
      debugPrint("===>获取电量失败：$error");
    }
  }

  @override
  void initState() {
    super.initState();

    exeEnv();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
