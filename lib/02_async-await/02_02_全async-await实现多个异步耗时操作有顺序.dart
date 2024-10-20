import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AsyncAwaitOrder2Widget extends StatefulWidget {
  const AsyncAwaitOrder2Widget({Key? key}) : super(key: key);

  @override
  State<AsyncAwaitOrder2Widget> createState() => _AsyncAwaitOrder2WidgetState();
}

/*
  二、async-await实现多个异步耗时操作有顺序
  既然存在”回调地狱“的困境，那把回调干掉不就完事了嘛，这就是async-await做的事情，async-await确实没回调了！
 */
/*
  2、全async-await实现多个异步耗时操作有顺序和Future实现多个异步耗时操作有顺序不同的地方
  实际上async-await除了在调用异步耗时操作函数阶段和Future有不同之外————即解决回调地狱问题以外（这是我们使用async-await第一大原因），
  在定义异步耗时操作阶段也可以有不同————即async-await的代码本身就可以比Future更加简洁清晰（当没有回调地狱时，我们依然可以使用async-await，这就是我们使用async-await第二大原因），
  所以这里的“全async-await”是在定义和调用异步耗时操作阶段都是用async-await
  ——————————————————————
  * 异步耗时操作函数定义阶段：
    * （0）上来二话不说，先用async关键字修饰一下异步耗时操作函数
    * （1）异步耗时操作函数的【参数】：不需要变，保持没有回调函数这样的参数
    * （2）异步耗时操作函数的【返回值】：不需要变，保持返回一个Future对象、以便外界监听异步耗时操作的结果（不过这里不再需要我们显式地返回一个Future对象，async函数会帮我们自动返回一个Future对象）
    * （3）异步耗时操作函数的【执行体】：需要变、且变得非常彻底、每一步都变了
      * ① 【创建Future对象和返回Future对象的变化】：原来我们是显性地手动创建了一个Future对象、并返回了这个Future对象，现在不需要了，async函数内部会隐式地自动创建一个Future对象、我们只需要返回普通数据类型的值即可、async函数内部会自动把普通数据类型的值包装进Future对象并返回Future对象
      * ② 【耗时耗时操作放在哪里执行的变化】：原来我们是把耗时操作放在Future对象的executor函数里执行的，现在不是了，而是要放在try-catch里执行，因为我们需要通过await来等待异步耗时操作成功的数据和用catch来捕获异步耗时操作失败的错误
      * ③ 【上报成功数据和失败错误方式的变化】：原来我们是通过Future对象的executor函数的complete上报耗时操作执行成功的数据、completeError上报耗时操作执行失败的错误，现在不是了，现在是通过异步耗时操作函数的返回值上报成功的数据————代替complete，通过在异步任务函数执行体里抛出异常来上报失败的信息————代替completeError（此时回想一下我们在使用很多三方库的时候，人家的一些异步任务超时后或者访问不到后都是直接给外界throw Error，这就是一个标准做法，我们以后在设计async函数时也要这样设计）
  ——————————————————————
  * 异步耗时操作函数调用阶段：
    * 原来我们是通过Future对象.then的第一个函数来监听成功的数据
    * 现在是用await来监听成功的数据；当然await除了具备监听成功的数据这一大功能外，await的第二大功能就是它会卡在这里一直等、直到等到了成功的数据才会放行，这也是为什么await能实现多个异步耗时操作按顺序串行执行的原因
    
    * 原来我们是通过Future对象.then的第二个函数来监听失败的错误
    * 现在用try-catch的catch来监听失败的错误（也就是说我们一旦使用了async-await这一套，就一定要为await随身绑定一套try-catch，否则异步耗时操作执行失败的错误没人处理的话代码也会崩溃。这也是为什么我们在使用很多三方库的时候，发现人家的一些异步任务超时后或者访问不到后都是直接给外界throw Error，我们不用try-catch处理的话代码就会崩溃的原因）
 */
class _AsyncAwaitOrder2WidgetState extends State<AsyncAwaitOrder2Widget> {
  // getInterface1Async不再是一个同步函数了，而是一个异步函数，把它搞成异步函数有两个好处：
  // 1、它内部的异步耗时操作就可以不用Future来写了，而是可以用await来写（因为await只能用在async函数里），这样代码可以更加简洁清晰
  // 2、外界在调用这个异步耗时操作函数时，也不会阻塞主线程（毕竟是个耗时操作嘛），而是可以继续执行其它操作，效率更高，当然我们要自己注意好操作的同步问题
  Future<Response<dynamic>> getInterface1() async {
    try {
      // 卡在这里等待接口成功的数据
      final value = await Dio().get("https://www.bing.com");
      // 这就是在上报成功的数据（会自动包装进一个Future对象返回）
      return value;
    } catch (error) {
      // 捕获接口失败的错误，并用throw Error上报失败的错误
      throw error;
    }
  }

  // getInterface2Async不再是一个同步函数了，而是一个异步函数
  Future<Response<dynamic>> getInterface2() async {
    try {
      // 卡在这里等待接口成功的数据
      final value = await Dio().get("https://www.bing.com");
      // 这就是在上报成功的数据（会自动包装进一个Future对象返回）
      return value;
    } catch (error) {
      // 捕获接口失败的错误，并用throw Error上报失败的错误
      rethrow;
    }
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
