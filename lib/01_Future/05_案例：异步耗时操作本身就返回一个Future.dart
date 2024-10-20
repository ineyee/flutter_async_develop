import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FutureOperationWidget extends StatefulWidget {
  const FutureOperationWidget({Key? key}) : super(key: key);

  @override
  State<FutureOperationWidget> createState() => _FutureOperationWidgetState();
}

/*
  这个案例模拟的就是“异步耗时操作本身就返回一个Future，比如网络请求、本地IO操作”的场景
 */
class _FutureOperationWidgetState extends State<FutureOperationWidget> {
  // 封装一个业务层的get请求
  Future<Response<dynamic>> get() {
    final Completer completer = Completer<Response<dynamic>>();

    // get请求是个异步耗时操作，并且get请求这个异步耗时操作本身就返回一个Future
    // 于是我们就能通过这个异步耗时操作返回的Future对象.then来监听到它执行成功和失败的时机，然后分别调用complete和completeError了
    Dio().get("https://www.baidu.com").then(
      (value) {
        if (completer.isCompleted == false) {
          completer.complete(value);
        }
      },
      onError: (error) {
        if (completer.isCompleted == false) {
          completer.completeError(error);
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
