import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:barapp/pages/WebViewPage.dart';
import 'package:in_app_review/in_app_review.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String version = '';

  Future getVer() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  void initState() {
    super.initState();
    getVer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        backgroundColor: Color.fromARGB(31, 70, 68, 68),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 35, left: 8, right: 8),
        child: Column(
          children: [
            InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return WebViewPage();
                      },
                    ),
                  );
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'お問い合わせ',
                        style: TextStyle(fontSize: 17),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 25,
                      )
                    ],
                  ),
                )),
            SizedBox(
              height: 25,
            ),
            InkWell(
                onTap: () async {
                  final InAppReview inAppReview = InAppReview.instance;
                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
                  }
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'アプリを評価する',
                        style: TextStyle(fontSize: 17),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 25,
                      )
                    ],
                  ),
                )),
            SizedBox(
              height: 25,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'バージョン',
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    '${version}',
                    style: TextStyle(fontSize: 17),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
