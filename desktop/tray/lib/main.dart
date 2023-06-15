import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:system_tray/system_tray.dart';
import 'package:tray/tray.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 托盘操作的逻辑封装
  final Tray _tray = Tray('app_icon');
  // 菜单1
  final Menu _menuMain = Menu();
  // 菜单2
  final Menu _menuSimple = Menu();
  // true显示菜单1，false显示菜单2
  bool _toggleMenu = true;

  @override
  void initState() {
    super.initState();
    initSystemTray();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 设置托盘窗口内的菜单窗口
  // MenuItemLabel 普通菜单
  // MenuSeparator 分割线
  // SubMenu 带展开操作的菜单
  // MenuItemCheckbox Checkbox菜单
  Future<void> initSystemTray() async {
    List<String> iconList = ['darts_icon', 'gift_icon'];
    await _menuMain.buildFrom(
      [
        MenuItemLabel(
          label: 'Change Context Menu',
          image: _tray.getImagePath('darts_icon'),
          onClicked: (menuItem) {
            debugPrint("Change Context Menu");

            _toggleMenu = !_toggleMenu;
            _tray.setContextMenu(_toggleMenu ? _menuMain : _menuSimple);
          },
        ),
        MenuSeparator(),
        MenuItemLabel(
            label: 'Show',
            image: _tray.getImagePath('darts_icon'),
            onClicked: (menuItem) => _tray.appWindow.show()),
        MenuItemLabel(
            label: 'Hide',
            image: _tray.getImagePath('darts_icon'),
            onClicked: (menuItem) => _tray.appWindow.hide()),
        MenuItemLabel(
          label: 'Start flash tray icon',
          image: _tray.getImagePath('darts_icon'),
          onClicked: (menuItem) {
            debugPrint("Start flash tray icon");
            _tray.flash();
          },
        ),
        MenuItemLabel(
          label: 'Stop flash tray icon',
          image: _tray.getImagePath('darts_icon'),
          onClicked: (menuItem) {
            debugPrint("Stop flash tray icon");
            _tray.stopFlash();
          },
        ),
        MenuSeparator(),
        SubMenu(
          label: "Test API",
          image: _tray.getImagePath('gift_icon'),
          children: [
            SubMenu(
              label: "setSystemTrayInfo",
              image: _tray.getImagePath('darts_icon'),
              children: [
                MenuItemLabel(
                  label: 'setTitle',
                  image: _tray.getImagePath('darts_icon'),
                  onClicked: (menuItem) {
                    debugPrint("click 'setTitle' : setSystemTrayInfo");
                    _tray.systemTray.setTitle('setSystemTrayInfo');
                  },
                ),
                MenuItemLabel(
                  label: 'setImage',
                  image: _tray.getImagePath('gift_icon'),
                  onClicked: (menuItem) {
                    String iconName =
                        iconList[Random().nextInt(iconList.length)];
                    String path = _tray.getTrayImagePath(iconName);
                    debugPrint("click 'setImage' : $path");
                    _tray.systemTray.setImage(path);
                  },
                ),
                MenuItemLabel(
                  label: 'setToolTip',
                  image: _tray.getImagePath('darts_icon'),
                  onClicked: (menuItem) {
                    debugPrint("click 'setToolTip' : setToolTip");
                    _tray.systemTray.setToolTip('setToolTip');
                  },
                ),
                MenuItemLabel(
                  label: 'getTitle',
                  image: _tray.getImagePath('gift_icon'),
                  onClicked: (menuItem) async {
                    String title = await _tray.systemTray.getTitle();
                    debugPrint("click 'getTitle' : $title");
                  },
                ),
              ],
            ),
            MenuItemLabel(
                label: 'disabled Item',
                name: 'disableItem',
                image: _tray.getImagePath('gift_icon'),
                enabled: false),
          ],
        ),
        MenuSeparator(),
        MenuItemLabel(
          label: 'Set Item Image',
          onClicked: (menuItem) async {
            debugPrint("click 'SetItemImage'");

            String iconName = iconList[Random().nextInt(iconList.length)];
            String path = _tray.getImagePath(iconName);

            await menuItem.setImage(path);
            debugPrint(
                "click name: ${menuItem.name} menuItemId: ${menuItem.menuItemId} label: ${menuItem.label} image: ${menuItem.image}");
          },
        ),
        MenuItemCheckbox(
          label: 'Checkbox 1',
          name: 'checkbox1',
          checked: true,
          onClicked: (menuItem) async {
            debugPrint("click 'Checkbox 1'");

            MenuItemCheckbox? checkbox1 =
                _menuMain.findItemByName<MenuItemCheckbox>("checkbox1");
            await checkbox1?.setCheck(!checkbox1.checked);

            MenuItemCheckbox? checkbox2 =
                _menuMain.findItemByName<MenuItemCheckbox>("checkbox2");
            await checkbox2?.setEnable(checkbox1?.checked ?? true);

            debugPrint(
                "click name: ${checkbox1?.name} menuItemId: ${checkbox1?.menuItemId} label: ${checkbox1?.label} checked: ${checkbox1?.checked}");
          },
        ),
        MenuItemCheckbox(
          label: 'Checkbox 2',
          name: 'checkbox2',
          onClicked: (menuItem) async {
            debugPrint("click 'Checkbox 2'");

            await menuItem.setCheck(!menuItem.checked);
            await menuItem.setLabel('Checkbox 2');
            debugPrint(
                "click name: ${menuItem.name} menuItemId: ${menuItem.menuItemId} label: ${menuItem.label} checked: ${menuItem.checked}");
          },
        ),
        MenuItemCheckbox(
          label: 'Checkbox 3',
          name: 'checkbox3',
          checked: true,
          onClicked: (menuItem) async {
            debugPrint("click 'Checkbox 3'");

            await menuItem.setCheck(!menuItem.checked);
            debugPrint(
                "click name: ${menuItem.name} menuItemId: ${menuItem.menuItemId} label: ${menuItem.label} checked: ${menuItem.checked}");
          },
        ),
        MenuSeparator(),
        MenuItemLabel(
            label: 'Exit', onClicked: (menuItem) => _tray.appWindow.close()),
      ],
    );

    await _menuSimple.buildFrom([
      MenuItemLabel(
        label: 'Change Context Menu',
        image: _tray.getImagePath('app_icon'),
        onClicked: (menuItem) {
          debugPrint("Change Context Menu");

          _toggleMenu = !_toggleMenu;
          _tray.systemTray
              .setContextMenu(_toggleMenu ? _menuMain : _menuSimple);
        },
      ),
      MenuSeparator(),
      MenuItemLabel(
          label: 'Show',
          image: _tray.getImagePath('app_icon'),
          onClicked: (menuItem) => _tray.appWindow.show()),
      MenuItemLabel(
          label: 'Hide',
          image: _tray.getImagePath('app_icon'),
          onClicked: (menuItem) => _tray.appWindow.hide()),
      MenuItemLabel(
        label: 'Exit',
        image: _tray.getImagePath('app_icon'),
        onClicked: (menuItem) => _tray.appWindow.close(),
      ),
    ]);
    _tray.setContextMenu(_menuMain);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            ContentBody(
              tray: _tray,
              menu: _menuMain,
            ),
          ],
        ),
      ),
    );
  }
}

class ContentBody extends StatelessWidget {
  final Tray tray;
  final Menu menu;

  const ContentBody({
    Key? key,
    required this.tray,
    required this.menu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: const Color(0xFFFFFFFF),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          children: [
            Card(
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'systemTray.initSystemTray',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      'Create system tray.',
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    ElevatedButton(
                      child: const Text("initSystemTray"),
                      onPressed: () async {
                        if (await tray.initTray()) {
                          tray.systemTray.setTitle("new system tray");
                          tray.systemTray.setToolTip(
                              "How to use system tray with Flutter");
                          tray.setContextMenu(menu);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'systemTray.destroy',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      'Destroy system tray.',
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    ElevatedButton(
                      child: const Text("destroy"),
                      onPressed: () async {
                        await tray.destroyTray();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
