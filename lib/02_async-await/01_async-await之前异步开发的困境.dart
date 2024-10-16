import 'package:flutter/material.dart';

// 一、async-await之前异步开发的困境
/*
  1、实际开发中，我们经常会面临这样的需求：即有好几个异步任务要做，但是它们之间有顺序，得等上一个执行才能执行下一个，如果用Future来做的话，代码将是下面这样
 */
class FutureHellWidget extends StatefulWidget {
  const FutureHellWidget({Key? key}) : super(key: key);

  @override
  State<FutureHellWidget> createState() => _FutureHellWidgetState();
}

class _FutureHellWidgetState extends State<FutureHellWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
