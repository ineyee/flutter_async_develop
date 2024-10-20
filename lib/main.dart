import 'package:flutter/material.dart';

import '01_Future/01_Future之前异步编程的困境.dart';
import '01_Future/02_Future实现异步编程.dart';
import '01_Future/03_案例：Future实现异步耗时操作的超时机制.dart';
import '01_Future/04_案例：Future实现异步耗时操作的结果不在异步耗时操作函数本身里.dart';
import '01_Future/05_案例：异步耗时操作本身就返回一个Future.dart';
import '01_Future/06_案例：Future.wait.dart';

import '02_async-await/01_async-await之前异步编程的困境.dart';
import '02_async-await/02_01_半async-await实现多个异步耗时操作有顺序.dart';
import '02_async-await/02_02_全async-await实现多个异步耗时操作有顺序.dart';
import '02_async-await/03_案例：async-await实现异步耗时操作的超时机制.dart';
import '02_async-await/04_案例：async-await实现异步耗时操作的结果不在异步耗时操作函数本身里.dart';
import '02_async-await/05_案例：异步耗时操作本身就返回一个Future.dart';
import '03_后语.dart';

void main() {
  // runApp(const CallbackWidget());
  // runApp(const FutureWidget());
  // runApp(const FutureTimeoutWidget());
  // runApp(const FutureMultiWidget());
  // runApp(const FutureOperationWidget());
  // runApp(const FutureWaitWidget());

  // runApp(const FutureHellWidget());
  // runApp(const AsyncAwaitOrder1Widget());
  // runApp(const AsyncAwaitOrder2Widget());
  // runApp(const AsyncAwaitTimeoutWidget());
  // runApp(const AsyncAwaitMultiWidget());
  // runApp(const AsyncAwaitOperationWidget());

  runApp(const AfterWidget());
}
