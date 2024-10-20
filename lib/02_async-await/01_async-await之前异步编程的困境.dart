import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class FutureHellWidget extends StatefulWidget {
  const FutureHellWidget({Key? key}) : super(key: key);

  @override
  State<FutureHellWidget> createState() => _FutureHellWidgetState();
}

// 一、async-await之前异步开发的困境
/*
  1、实际开发中，我们经常会面临这样的需求：有好几个异步任务同时要做，但是它们之间有顺序，得等上一个执行完才能执行下一个

  比如我们得在接口1请求成功之后才能去请求接口2，如果用Future来实现的话，代码将是下面这样：
 */
class _FutureHellWidgetState extends State<FutureHellWidget> {
  Future<Response<dynamic>> getInterface1() {
    final Completer completer = Completer<Response<dynamic>>();

    Dio().get("https://www.bing.com").then(
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

  Future<Response<dynamic>> getInterface2() {
    final Completer completer = Completer<Response<dynamic>>();

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

    getInterface1().then(
      (value) {
        debugPrint("===>接口1请求成功：$value");

        getInterface2().then(
          (value) {
            debugPrint("===>接口2请求成功：$value");
          },
          onError: (error) {
            debugPrint("===>接口2请求失败：$error");
          },
        );
      },
      onError: (error) {
        debugPrint("===>接口1请求失败：$error");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
/*
  2、Future实现多个异步耗时操作有顺序时的困境
  很长一段时间内我们都是通过Future来实现多个异步耗时操作有顺序的，这样做绝对没问题，但是存在弊端：
  * 那就是”回调地狱“，看上面请求部分一层一层的嵌套，看着有点难受，如果再多获取几个信息，那将是绝杀

  既然存在”回调地狱“的困境，那把回调干掉不就完事了嘛，这就是async-await做的事情！
 */
