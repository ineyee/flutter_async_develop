import 'package:flutter/material.dart';

class BeforeWidget extends StatefulWidget {
  const BeforeWidget({Key? key}) : super(key: key);

  @override
  State<BeforeWidget> createState() => _BeforeWidgetState();
}

class _BeforeWidgetState extends State<BeforeWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

/*
  一、同步耗时操作和异步耗时操作

  1、操作
  我们把“执行一段代码”称之为一个“操作”，比如：
  ① const num = 1 + 1; 是一个操作
  ② let i = 0;
     while (i < 10000000000000) {
      i++;
     } 是一个操作
  ③ 网络请求、本地IO操作、蓝牙通信、setTimeout等都是一个操作

  2、耗时操作和非耗时操作
  而操作可以分为耗时操作和非耗时操作

  非耗时操作是指那些执行起来耗时为指令级别的操作，比如const num = 1 + 1; 就是一个非耗时操作，它的耗时是微秒级甚至纳秒级

  耗时操作是指那些执行起来耗时比较长的操作，比如
  let i = 0;
  while (i < 10000000000000) {
    i++;
  } 就是一个耗时操作，网络请求、本地IO操作、蓝牙通信、setTimeout等都是一个耗时操作，它们的耗时是毫秒级甚至秒级

  3、同步耗时操作和异步耗时操作
  而耗时操作又可以分为同步耗时操作和异步耗时操作

  同步耗时操作是指那些执行它时会卡在那、等它执行完才会执行后续操作的耗时操作，比如
  let i = 0;
  while (i < 10000000000000) {
    i++;
  } 就是一个同步耗时操作

  异步耗时操作是指那些执行它时不会卡在那、而是会立即执行后续操作的耗时操作，比如网络请求、本地IO操作、蓝牙通信、setTimeout等都是一个异步耗时操作
 */

/*
  二、同步函数和异步函数
  同步函数是指那些执行它时会卡在那、等它执行完才会执行后续操作的函数
  异步函数是指那些执行它时不会卡在那、而是会立即执行后续操作的函数
 */

/*
  三、异步编程及其实现方案
  我们通常所说的异步编程就是指通过【同步函数或异步函数】来处理【异步耗时操作】
  具体地说就是，因为执行异步耗时操作时不会卡在那等结果、而是会立即执行后续的操作，所以得有一种方案、得能在异步耗时操作执行完毕时、来拿到异步耗时操作的结果

  常用的异步编程实现方案（说白了就是异步耗时操作执行完毕时、拿异步耗时操作结果的方案）有：回调函数、Future、async-await
  其中回调函数和Future是通过同步函数来处理异步耗时操作的
  而async-await是通过异步函数来处理异步耗时操作的
 */
