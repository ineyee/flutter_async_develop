import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// 异步任务函数里的耗时操作本身就是个Future
class FutureOperationWidget extends StatefulWidget {
  const FutureOperationWidget({Key? key}) : super(key: key);

  @override
  State<FutureOperationWidget> createState() => _FutureOperationWidgetState();
}

class _FutureOperationWidgetState extends State<FutureOperationWidget> {
  Future<Response<dynamic>> get() {
    final Completer completer = Completer<Response<dynamic>>();

    // 前面我们举得例子中耗时操作本身都不是一个Future
    // 耗时操作本身————要么是在当前异步任务函数里sleep延时几秒后就能得到耗时操作的结果，要么是在别的监听函数里不知道等多久能得到耗时操作的结果
    // 但如果耗时操作本身就是个Future且能在当前异步任务函数里等待一段时间后就能得到耗时操作的结果，代码该怎么写呢？
    //
    // Dio()会返回一个Dio对象
    // Dio对象的get请求是个耗时操作，且get请求这个耗时操作本身就返回一个Future
    // 于是我们就能通过耗时操作这个Future的then监听到它执行成功和失败的时机，来分别调用complete和completeError了
    Dio().get("https://www.baidu.com").then(
      (value) {
        // 都要做下判断，否则很可能已经走了completeError，再走complete就会报错
        if (completer.isCompleted == false) {
          completer.complete(value);
        }
      },
      onError: (errorMsg) {
        if (completer.isCompleted == false) {
          completer.completeError(errorMsg);
        }
      },
    );

    return completer.future as Future<Response<dynamic>>;
  }

  @override
  void initState() {
    super.initState();

    final Future<Response<dynamic>> future = get();
    future.then(
      (value) {
        debugPrint("===>get请求成功：$value");
      },
      onError: (error) {
        debugPrint("===>get请求失败：$error");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
