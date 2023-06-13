import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
  // 初始化窗口的大小
  doWhenWindowReady(() {
    Size initialSize = const Size(600, 450);
    appWindow.size = initialSize;
    // 设置最小窗口，避免窗口过小报错
    appWindow.minSize = initialSize;
    // 自定义任务栏上弹窗显示的标题
    appWindow.title = 'My App';
    // 必须调用，否则窗口不显示
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  Color borderColor = const Color(0xFF805306);

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // 添加边框
        body: WindowBorder(
          width: 1,
          color: borderColor,
          child: Row(
            children: [
              // 左侧内容
              LeftSide(),
              // 右侧内容
              RightSide()
            ],
          ),
        ),
      ),
    );
  }
}

class RightSide extends StatelessWidget {
  // 背景渐变色开始颜色
  Color bgStart = const Color(0xFFF6D500);

  // 背景渐变色终止颜色
  Color bgEnd = const Color(0xFFF6A00C);

  RightSide({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        // 渐变起始位置
        begin: Alignment.topCenter,
        // 渐变终止位置
        end: Alignment.bottomCenter,
        // 渐变用到的颜色，可以不止起始和终止2种颜色，起始和终止颜色只是表明在起始位置和终止位置处的颜色
        colors: [bgStart, Colors.green, bgEnd],
        // 值在0、1间，如果指定stops那么元素个数和colors一致
        // stops: [0, 0.8, 1]
      )),
      child: Column(
        children: [
          // 顶部操作
          WindowTitleBarBox(
            child: Row(
              children: [
                // 设置该区域可拖动整个窗口
                Expanded(child: MoveWindow()),
                // 设置最小化、最大化、关闭按钮
                const WindowButtons()
              ],
            ),
          )
        ],
      ),
    ));
  }
}

class LeftSide extends StatelessWidget {
  Color bg = const Color(0xFFF6A00C);

  LeftSide({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Container(
        color: bg,
        child: Column(
          children: [
            // 设置顶部
            WindowTitleBarBox(
              // 设置该区域可拖动整个窗口
              child: MoveWindow(),
            )
          ],
        ),
      ),
    );
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: const Color(0xFF805306),
    mouseOver: const Color(0xFFF6A00C),
    mouseDown: const Color(0xFF805306),
    iconMouseOver: const Color(0xFF805306),
    iconMouseDown: const Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF805306),
    iconMouseOver: Colors.white);

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
