import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AsyncAwaitOperationWidget extends StatefulWidget {
  const AsyncAwaitOperationWidget({Key? key}) : super(key: key);

  @override
  State<AsyncAwaitOperationWidget> createState() =>
      _AsyncAwaitOperationWidgetState();
}

/*
  这个案例模拟的就是“异步耗时操作本身就返回一个Future，比如网络请求、本地IO操作”的场景
  
  这种场景就既能用半async-await也能用全async-await了，此时推荐使用全async-await
 */
class _AsyncAwaitOperationWidgetState extends State<AsyncAwaitOperationWidget> {
  // 封装一个业务层的get请求
  Future<Response<dynamic>> get() async {
    // get请求是个异步耗时操作，并且get请求这个异步耗时操作本身就返回一个Future
    // 这里我们不通过这个异步耗时操作返回的Future对象.then来监听到它执行成功和失败的时机，然后分别调用complete和completeError，而是用await和try catch来监听
    try {
      final value = await Dio().get("https://www.bing.com");
      return value;
    } catch (error) {
      throw error;
    }
  }

  Future exeEnv() async {
    try {
      // 卡在这里等待接口成功的数据
      final value = await get();
      debugPrint("===>接口请求成功：$value");

      // 这就是在上报成功的数据（会自动包装进一个Future对象返回）
      return value;
    } catch (error) {
      debugPrint("===>接口请求失败：$error");

      rethrow;
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
