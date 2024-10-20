import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AsyncAwaitOrder1Widget extends StatefulWidget {
  const AsyncAwaitOrder1Widget({Key? key}) : super(key: key);

  @override
  State<AsyncAwaitOrder1Widget> createState() => _AsyncAwaitOrder1WidgetState();
}

/*
  二、async-await实现多个异步耗时操作有顺序
  既然存在”回调地狱“的困境，那把回调干掉不就完事了嘛，这就是async-await做的事情，async-await确实没回调了！
 */
/*
  1、半async-await实现多个异步耗时操作有顺序和Future实现多个异步耗时操作有顺序不同的地方
  这里的”半async-await“是指异步耗时操作函数定义阶段还是使用Future，仅在异步耗时操作函数调用阶段使用async-await，我们一步一步来得出最终的结论
  ——————————————————————
  * 异步耗时操作函数定义阶段：
    * 完全不需要变，可以保持跟使用Future时一模一样
  ——————————————————————
  * 异步耗时操作函数调用阶段：
    * 原来我们是通过Future对象.then的第一个函数来监听成功的数据
    * 现在是用await来监听成功的数据；
    当然await除了具备监听成功的数据这一大功能外，await的第二大功能就是它会卡在这里一直等、直到等到了成功的数据才会放行，这也是为什么await能实现多个异步耗时操作按顺序串行执行的原因

    * 原来我们是通过Future对象.then的第二个函数来监听失败的错误
    * 现在用try-catch的catch来监听失败的错误
    （也就是说我们一旦使用了async-await这一套，就一定要为await随身绑定一套try-catch，否则异步耗时操作执行失败的错误没人处理的话代码也会崩溃。这也是为什么我们在使用很多三方库的时候，发现人家的一些异步任务超时后或者访问不到后都是直接给外界throw Error，我们不用try-catch处理的话代码就会崩溃的原因）
  ——————————————————————
    综上，也就是说Future对象的executor函数里一旦调用了completer（即成功上报函数）函数、就一定会触发await，executor函数里一旦调用了completeError（即失败上报函数）函数、就一定会触发try-catch的catch
 */
class _AsyncAwaitOrder1WidgetState extends State<AsyncAwaitOrder1Widget> {
  // getInterface1还是原来的同步函数 + Future
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

  // getInterface2还是原来的同步函数 + Future
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

  Future getAllInterface() async {
    try {
      // 卡在这里等接口1成功的数据，然后再放行去获取接口2
      final value1 = await getInterface1();
      debugPrint("===>接口1请求成功：$value1");

      // 卡在这里等接口2成功的数据
      final value2 = await getInterface2();
      debugPrint("===>接口2请求成功：$value2");
    } catch (error) {
      debugPrint("===>接口1请求失败 | 接口2请求成功失败：$error");
    }
  }

  @override
  void initState() {
    super.initState();

    getAllInterface();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
