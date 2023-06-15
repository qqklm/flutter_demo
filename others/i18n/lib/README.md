1. 添加依赖，[官方文档](https://pub.dev/packages/slang)
    ```yml
    dependencies:
      flutter_localizations: # add this
        sdk: flutter
      slang: 3.18.1
      slang_flutter: 3.18.0
   
    dev_dependencies:
      build_runner: 2.4.5
      slang_build_runner: 3.18.0
    ```
2. 创建国际化文件
   - 项目根目录下创建assets/i18n文件夹
   - 在创建的文件夹下创建国际化文件
     - strings.i18n.json <-- 默认国际化文件
     - strings_zh-CN.i18n.json <-- 简体中文国际化文件
     - strings_en-US.i18n.json <-- 美式英语际化文件
     - strings_zh.i18n.json <-- 中文国际化文件（最好都使用语种-地区格式或者语种格式，不要混合使用）
3. 在pubspec.yaml文件中配置资源文件
   ```yml
   flutter:
     assets:
       - assets/i18n/   
      ```
4. 执行命令生成相关代码
    ```shell
   # 在lib目录下生成gen/strings.g.dart文件
    dart run slang
    ```
5. 配置代码
   ```dart
   // 在需要使用的地方导包 
   import 'package:i18n/gen/strings.g.dart';
   WidgetsFlutterBinding.ensureInitialized();
   runApp(TranslationProvider(child: MyApp())); // Wrap your app with TranslationProvider
   
   MaterialApp(
    locale: TranslationProvider.of(context).flutterLocale, // use provider
    supportedLocales: AppLocaleUtils.supportedLocales,
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    child: YourFirstScreen(),
    )
   ```
6. 说明
    - 无需手都执行setState
    - 动态模板默认占位符是dart的格式即${param}