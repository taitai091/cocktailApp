import 'dart:io';
import 'package:barapp/model/BarEvent.dart';
import 'package:barapp/pages/AddBarEvent.dart';
import 'package:barapp/pages/EditBarEvent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barapp/model/app.dart';
import 'package:barapp/main.dart';
import 'package:device_info_plus/device_info_plus.dart';

class BarListPage extends StatefulWidget {
  const BarListPage({super.key});

  @override
  State<BarListPage> createState() => _BarListPageState();
}

class _BarListPageState extends State<BarListPage> {
  String? BarTitle;
  double? BarRating;
  String? BarDate;
  var BarListReference = FirebaseFirestore.instance
      .collection('Users')
      .doc(iosDeviceInfo)
      .collection('BarLists')
      .withConverter<BarEvent>(fromFirestore: ((snapshot, _) {
    return BarEvent.fromFirestore(snapshot);
  }), toFirestore: ((value, _) {
    return value.toMap();
  }));

  final prefs = SharedPreferences.getInstance();
  String? value = 'Default';

  @override
  void initState(){
    super.initState();
    setState(() {});
    init();
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      value = prefs.getString('text');
    });
  }

  

  selectStream() {
    Stream<QuerySnapshot<BarEvent>> _Default =
        BarListReference.orderBy('sendTime', descending: true).snapshots();
    Stream<QuerySnapshot<BarEvent>> _starStream =
        BarListReference.orderBy('star').snapshots();
    Stream<QuerySnapshot<BarEvent>> _starStreamDes =
        BarListReference.orderBy('star', descending: true).snapshots();
    Stream<QuerySnapshot<BarEvent>> _timeStream =
        BarListReference.orderBy('sendTime').snapshots();
    if (value == 'Default') {
      return _Default;
    } else if (value == 'timeStream') {
      return _timeStream;
    } else if (value == 'starStreamDes') {
      return _starStreamDes;
    } else if (value == 'starStream') {
      return _starStream;
    } else if (value == null) {
      return _Default;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bar'),
        backgroundColor: Color.fromARGB(31, 70, 68, 68),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 150,
              child: DrawerHeader(
                child: Row(
                  children: [
                    const Text(
                      '並べ替え',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.swap_vert,
                      size: 28,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text('日付昇順'),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('text', 'Default');
                setState(() {
                  value = 'Default';
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('日付降順'),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('text', 'timeStream');
                setState(() {
                  value = 'timeStream';
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('評価高い順'),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('text', 'starStreamDes');
                setState(() {
                  value = 'starStreamDes';
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('評価低い順'),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('text', 'starStream');
                setState(() {
                  value = 'starStream';
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot<BarEvent>>(
        stream: selectStream(),
        builder: (context, snapshot) {
          final docs = snapshot.data?.docs ?? [];
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final barEvent = docs[index].data();
              return List(barEvent: barEvent);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newBarInfo = await Navigator.of(context).push<BarEvent>(
            MaterialPageRoute(
              builder: (context) {
                return const AddBarEvent();
              },
            ),
          );
          if (newBarInfo != null) {
            BarTitle = newBarInfo.name;
            BarRating = newBarInfo.star;
            BarDate = newBarInfo.sendTime;
            setState(() {});
          }
        },
      ),
    );
  }
}

class List extends StatelessWidget {
  List({
    super.key,
    required this.barEvent,
  });

  BarEvent barEvent;

  Future<void> deleteImage() async {
    final ref = FirebaseStorage.instance.ref(barEvent.ref1);
    await ref.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 9, right: 9, bottom: 8),
      child: Container(
        width: double.infinity,
        height: 110,
        child: InkWell(
          onTap: () {
            ListTap(context);
          },
          child: Card(
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Row(
              children: [
                if (barEvent.remotePath != null)
                  SizedBox(
                    width: 95,
                    height: double.infinity,
                    child: Image.network(
                      barEvent.remotePath.toString(),
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  SizedBox(
                    width: 95,
                    height: double.infinity,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 50,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 5, left: 15, right: 0, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(barEvent.sendTime),
                      Container(
                        width: 220,
                        child: Text(
                          barEvent.name,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RatingBarIndicator(
                            itemSize: 25,
                            itemBuilder: (context, index) => const Icon(
                              Icons.local_bar,
                              color: Colors.yellow,
                            ),
                            rating: barEvent.star,
                          ),
                          SizedBox(width: 10),
                          if (barEvent.deskCount == '1~5')
                            Icon(
                              Icons.chair_alt,
                              size: 15,
                            )
                          else if (barEvent.deskCount == '6~10' ||
                              barEvent.deskCount == '11~20')
                            Row(
                              children: [
                                Icon(
                                  Icons.chair_alt,
                                  size: 15,
                                ),
                                Icon(
                                  Icons.chair_alt,
                                  size: 15,
                                )
                              ],
                            )
                          else if (barEvent.deskCount == '21~30' ||
                              barEvent.deskCount == '30~')
                            Row(
                              children: [
                                Icon(
                                  Icons.chair_alt,
                                  size: 15,
                                ),
                                Icon(
                                  Icons.chair_alt,
                                  size: 15,
                                ),
                                Icon(
                                  Icons.chair_alt,
                                  size: 15,
                                )
                              ],
                            )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> ListTap(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: 700,
            child: Column(
              children: [
                if (barEvent.remotePath != null)
                  Container(
                    height: 210,
                    width: double.infinity,
                    child: Image.network(
                      barEvent.remotePath.toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (c, o, s) {
                        return const Icon(
                          Icons.image_not_supported_outlined,
                          size: 50,
                        );
                      },
                    ),
                  )
                else
                  Container(
                    height: 210,
                    width: double.infinity,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 50,
                    ),
                  ),
                SizedBox(height: 10),
                Container(
                  height: 3,
                  width: 60,
                  color: Colors.black.withOpacity(0.3),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          barEvent.name,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '評価',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  barEvent.star.toString(),
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                RatingBarIndicator(
                                  itemSize: 22,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.local_bar,
                                    color: Colors.yellow,
                                  ),
                                  rating: barEvent.star,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 17),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '雰囲気',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              barEvent.huniki.toString(),
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 17),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '席数',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              '席数：${barEvent.deskCount.toString()}',
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        if (barEvent.memo == null)
                          const Text('メモ欄')
                        else
                          Container(
                            padding: EdgeInsets.all(8),
                            height: 120,
                            width: double.infinity,
                            color: Colors.black12,
                            child: SingleChildScrollView(
                              child: Text(
                                barEvent.memo!,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 10),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black12,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext) =>
                                          EditBarEvent(barEvent: barEvent),
                                    ),
                                  );
                                },
                                child: Text('編集'),
                              ),
                              SizedBox(width: 15),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black12,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Center(
                                          child: CupertinoAlertDialog(
                                            title: Text("削除しますか？"),
                                            actions: [
                                              CupertinoDialogAction(
                                                child: Text("いいえ"),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                              CupertinoDialogAction(
                                                  child: Text("はい"),
                                                  onPressed: () async {
                                                    await barEvent.reference
                                                        .delete();
                                                    if (barEvent.remotePath !=
                                                        null) {
                                                      await deleteImage();
                                                    }
                                                    setState() {}
                                                    Navigator.of(context)
                                                        .popUntil((route) =>
                                                            route.isFirst);
                                                  }),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Text('削除'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
