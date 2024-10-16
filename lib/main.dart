import 'package:flutter/material.dart';

import '01_Future/01_Future之前异步开发的困境.dart';
import '01_Future/02_Future实现异步开发.dart';
import '01_Future/03_案例：Future实现异步任务的超时机制.dart';
import '01_Future/04_案例：Future的complete上报是在别的函数里.dart';
import '01_Future/05_案例：异步任务函数里的耗时操作本身就是个Future.dart';
import '01_Future/06_案例：Future.wait.dart';

void main() {
  // runApp(const CallbackWidget());
  // runApp(const FutureWidget());
  // runApp(const FutureTimeoutWidget());
  // runApp(const FutureMultiWidget());
  // runApp(const FutureOperationWidget());
  runApp(const FutureWaitWidget());
}
