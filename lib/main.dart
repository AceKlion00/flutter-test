import 'package:extra_staff/utils/constants.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/messages.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:extra_staff/views/splash_screen.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://88860a0eff1c47f992da8f92edfc84f0@o1329473.ingest.sentry.io/6591681';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(ExtraStaff()),
  );
}

class ExtraStaff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      if (objABBottom.hideBottom != isKeyboardVisible) {
        objABBottom.hideBottom = isKeyboardVisible;
        objABBottom.update();
      }
      return KeyboardDismissOnTap(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: (e) {
            FocusManager.instance.primaryFocus?.unfocus();
            if (timer != null) {
              fallBackTimer(false);
            }
          },
          child: GetMaterialApp(
            title: 'es'.tr,
            theme: ThemeData.light(),
            darkTheme: ThemeData.light(),
            home: SplashPage(),
            enableLog: false,
            debugShowCheckedModeBanner: false,
            translations: Messages(),
            locale: Locale('en', ''),
            fallbackLocale: Locale('en', ''),
            onInit: () async {
              await localStorageInit();
              await Resume.shared.getClass();
              Services.shared.setData();
              if (isiOS) {
                await AppTrackingTransparency.requestTrackingAuthorization();
              }
            },
          ),
        ),
      );
    });
  }
}
