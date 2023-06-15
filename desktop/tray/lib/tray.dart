import 'dart:async';
import 'dart:io';

import 'package:system_tray/system_tray.dart';

class Tray {
  // 系统托盘图标
  String appIconName;

  Tray(this.appIconName);

  // 当前窗口
  final AppWindow appWindow = AppWindow();

  // 系统托盘
  final SystemTray systemTray = SystemTray();

  // toggle 标识系统托盘图标是否显示，当为false时，将图标的路径置为''
  bool _toggleTrayIcon = true;

  // 获取系统托盘图标路径
  String getTrayImagePath(String imageName) {
    return Platform.isWindows
        ? 'assets/images/$imageName.ico'
        : 'assets/images/$imageName.png';
  }

  // 获取系统托盘菜单leading图标路径
  String getImagePath(String imageName) {
    return Platform.isWindows
        ? 'assets/images/$imageName.bmp'
        : 'assets/images/$imageName.png';
  }

  // 定时执行，用于图标闪烁操作
  Timer? _timer;

  // 启动系统托盘图标闪烁
  void flash() {
    // 0.5秒执行一次
    _timer ??= Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) {
        _toggleTrayIcon = !_toggleTrayIcon;
        // 将图标路径置为空图标不显示
        systemTray
            .setImage(_toggleTrayIcon ? "" : getTrayImagePath(appIconName));
      },
    );
  }

  // 关闭系统托盘图标闪烁
  void stopFlash() {
    _timer?.cancel();
    _timer = null;
    // 便面在闪烁时点击后，图标不显示
    systemTray.setImage(getTrayImagePath(appIconName));
  }

  // 设置托盘窗口菜单，应该在调用initTray函数后执行
  void setContextMenu(Menu menu) {
    systemTray.setContextMenu(menu);
  }

  // 初始化系统托盘
  Future<bool> initTray({String title = '', String toolTip = ''}) async {
    // 设置系统托盘的相关属性，有些只在某个平台上起作用
    bool init = await systemTray.initSystemTray(iconPath: getTrayImagePath(appIconName));
    systemTray.setTitle(title);
    systemTray.setToolTip(toolTip);

    // 注册系统托盘的事件处理
    systemTray.registerSystemTrayEventHandler((eventName) {
      // 单击托盘图标
      if (eventName == kSystemTrayEventClick) {
        // 显示应用、显示托盘窗口
        Platform.isWindows ? appWindow.show() : systemTray.popUpContextMenu();
        // 右击托盘图标
      } else if (eventName == kSystemTrayEventRightClick) {
        // 显示托盘窗口、显示应用
        Platform.isWindows ? systemTray.popUpContextMenu() : appWindow.show();
      }
    });
    return Future.value(init);
  }

  // 关闭系统托盘
  destroyTray() async {
    await systemTray.destroy();
    stopFlash();
  }
}
