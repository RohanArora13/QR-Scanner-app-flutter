import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../utils/privacy_policy.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io' show Platform;

class MySetting extends StatelessWidget {
  const MySetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(title: Text('Settings')),
      body: SettingsList(
        darkTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).canvasColor,
        ),
        platform: DevicePlatform.android,
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile(
                onPressed: (context) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 16,
                          child: SingleChildScrollView(
                              child: Text(privacyPolicy).p(10)));
                    },
                  );
                },
                title: Text('Privacy Policy'),
                leading: Icon(Icons.privacy_tip),
              ),
              SettingsTile(
                onPressed: (context) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 16,
                          child: SingleChildScrollView(
                              child: Text(aboutUsText).p(10)));
                    },
                  );
                },
                title: Text('About Us'),
                leading: Icon(Icons.person),
              ),
              SettingsTile(
                onPressed: (context) => shareApp(context),
                title: Text('Share App'),
                leading: Icon(Icons.share),
              )
            ],
          ),
        ],
      ),
    );
  }

  void shareApp(context) {
    if (Platform.isAndroid) {
      Share.share('check out this cool barcode scanner app at');
    }
  }

  void toNotificationsScreen(BuildContext context) {
    // Navigation.navigateTo(
    //   context: context,
    //   screen: AndroidNotificationsScreen(),
    //   style: NavigationRouteStyle.material,
    // );
  }
}
