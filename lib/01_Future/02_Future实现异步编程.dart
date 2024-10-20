import 'dart:async';

import 'package:flutter/material.dart';

class FutureWidget extends StatefulWidget {
  const FutureWidget({Key? key}) : super(key: key);

  @override
  State<FutureWidget> createState() => _FutureWidgetState();
}

/*
  二、Future实现异步开发
  既然定义和调用异步耗时操作函数这两步会存在不统一的困境，那让这两步统一不就完事了嘛，这就是Future做的事情，
  所有的开发者都得按Future的固定写法来写！
  */
/*
  1、Future实现异步编程和回调函数实现异步编程不同的地方
  ——————————————————————
  * 定义异步耗时操作函数阶段：
    * （1）针对异步耗时操作函数的【参数】来说：
      * 原来我们是自定义successCallback、failureCallback等回调函数来上报异步耗时操作的结果的
      * 现在Future对象自带了两个函数complete（即成功上报函数）和completeError（即失败上报函数）来让我们上报异步耗时操作的结果，所以我们不再需要写回调函数这样的参数了
    * （2）针对异步耗时操作函数的【返回值】来说：
      * 原来是没有返回值的
      * 现在我们需要返回一个Future对象，以便外界监听异步耗时操作的结果
    * （3）针对异步耗时操作函数的【执行体】来说：
      * 原来我们是把异步耗时操作直接放在异步耗时操作函数里执行的
      * 现在需要创建一个Future对象并把异步耗时操作放在Future对象的executor函数里执行
      
      * 原来我们是通过回调函数上报异步耗时操作的结果的
      * 现在需要通过Future对象自带的两个函数complete（即成功上报函数）和completeError（即失败上报函数）来上报异步耗时操作的结果
  ——————————————————————
  * 调用异步耗时操作函数阶段：
    * 原来我们是通过回调函数来监听异步耗时操作的结果的
    * 现在我们是通过调用异步耗时操作函数先拿到一个Future对象，然后再通过Future对象的then方法来监听异步耗时操作的结果。那监听什么时候会被触发呢？
    Future对象的executor函数里一旦调用了complete（即成功上报函数）函数、就一定会触发then监听的第一个函数（即成功），
    executor函数里一旦调用了completeError（即失败上报函数）函数、就一定会触发then监听的第二个函数（即失败）
 */
class _FutureWidgetState extends State<FutureWidget> {
  // 同步函数 + 异步耗时操作 + Future上报和获取异步耗时操作执行完毕的结果
  // ① getDeviceBattery本身是个同步函数，我们把这个函数称为“异步耗时操作函数”，因为定义这个函数的目的就是为了执行它里面的“异步耗时操作”
  Future<int> getDeviceBattery() {
    // 创建Future对象
    //
    // 不过Flutter里不是直接创建Future对象，而是创建一个Completer对象，这个Completer对象自带一个Future对象
    // ① 这里的泛型只决定complete上报的数据类型、不决定completeError上报的数据类型
    // ② 同时这里的泛型也决定了completer.future的类型——即Future<int>，所以getDeviceBattery函数的返回值要跟这里匹配
    // ③ completeError可以上报任意数据类型的数据、且没法提前指定，我们随便传就行，并且无论这里传什么数据类型进去都不会影响completer.future的类型
    //
    // 而且Flutter里Future对象的executor函数不像JS里自带complete和completeError函数
    // 也是通过Completer对象的complete和completeError来上报成功和失败数据的
    // complete上报一定会触发future.then的第一个函数（即成功），completeError上报一定会触发future.then的第二个函数（即失败）
    final Completer completer = Completer<int>();

    // 我们可以把这里看做是Future对象的executor函数，类似于JS里Promise对象的executor函数
    {
      // ③ 这里是异步耗时操作，我们用setTimeout来模拟
      Timer(const Duration(milliseconds: 2000), () {
        // ④ 假设2s后，耗时操作执行完毕，通过Future对象自带的两个函数来上报结果
        // 成功时
        completer.complete(80);
        // 失败时
        // completer.completeError("正在充电，无法获取...");
      });
    }

    // 返回Future对象
    // 这里completer.future的类型是Future<dynamic>，但它实际的类型已经由上面的泛型确定了，这里得强转一下
    return completer.future as Future<int>;
  }

  @override
  void initState() {
    super.initState();

    // ⑤ 发起异步耗时操作函数，先拿到Future对象，然后再通过Future对象.then来监听异步耗时操作执行完毕的结果
    final Future<int> future = getDeviceBattery();
    future.then(
      (value) {
        debugPrint("===>获取电量成功：$value");
      },
      onError: (error) {
        debugPrint("===>获取电量失败：$error");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

/*
  2、Future实现异步开发的固定写法（实际开发中如果使用Future，那我们90%都是在写这种固定的写法，一定要特别熟练形成肌肉记忆）
  注意：then监听里一定要把成功和失败监听都写上，否则executor函数里触发then监听时项目会崩掉
  ——————————————————————
  // （1）定义异步耗时操作函数阶段：
  // 第一步：创建一个同步函数func————即异步耗时操作函数
  // 第二步：创建Future对象、返回Future对象
  // 第三步：把异步耗时操作放在Future对象的executor函数里执行
  // 第四步：异步耗时操作执行完毕时，通过complete来上报成功的数据，通过completeError来上报失败的错误
  Future<int> func() {
    // 创建Future对象
    //
    // 不过Flutter里不是直接创建Future对象，而是创建一个Completer对象，这个Completer对象自带一个Future对象
    // 注意：我们只能决定异步任务执行成功时返回的数据类型，不能决定执行失败时返回的数据类型——我们随便传什么类型进去都行、字符串也行、自定义Error也行
    final Completer completer = Completer<int>();

    // 我们可以把这里看做是Future对象的executor函数，类似于JS里Promise对象的executor函数
    {
      // 执行异步耗时操作...

      // 异步耗时操作执行完毕时
      // 通过complete来上报成功的数据
      completer.complete(value);
      // 通过completeError来上报失败的错误
      // completer.completeError(error);
    }

    // 返回Future对象
    return completer.future as Future<int>;
  }
  ——————————————————————
  // （2）调用方异步任务函数阶段
  // 第一步：先获取到异步耗时操作函数返回的Future对象
  // 第二步：通过Future对象.then来监听异步耗时操作执行完毕的结果
  final Future<int> future = func();
  future.then(
    (value) {
      // 异步耗时操作执行成功的监听
    },
    onError: (error) {
      // 异步耗时操作执行失败的监听
    },
  );
  ——————————————————————
*/

/*
  3、Future对象的2种状态
  * pending（待处理状态）：我们创建出来一个Future对象，如果从来没调用过它的complete或completeError上报数据，那它就会一直处于pending状态
  * completed（结束状态）：一旦调用complete或completeError上报数据，Future对象就会由pending状态锁定为completed状态、不会再更改
*/
