import 'package:barapp/model/BarEvent.dart';
import 'package:barapp/model/CocktailInfo.dart';
import 'package:barapp/pages/AddCocktailPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:barapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:barapp/main.dart';

class AddBarEvent extends StatefulWidget {
  const AddBarEvent({
    super.key,
  });

  @override
  State<AddBarEvent> createState() => _AddBarEventState();
}

class _AddBarEventState extends State<AddBarEvent> {
  String name = '';
  String deskCount = '1~5';
  String huniki = '明るい';
  String memo = '';
  double ratingCount = 0;
  String deskCount_selected = '';
  String huniki_selected = '';
  File? _image;
  String? remotePath;
  String? ref1;
  BarEvent? barEvent;
  final picker = ImagePicker();

  Future<PickedFile?> getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {}
    });
  }

  Future<void> uploadImage() async {
    try {
      if (_image != null) {
        String path = _image!.path.substring(_image!.path.lastIndexOf('/') + 1);
        final ref = FirebaseStorage.instance.ref(path);
        final storageImage = await ref.putFile(_image!);
        remotePath = await storageImage.ref.getDownloadURL();
        ref1 = path;
      } else {}
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteImage() async {
    String path = _image!.path.substring(_image!.path.lastIndexOf('/') + 1);
    final ref = FirebaseStorage.instance.ref(path);
    await ref.delete();
  }

  void _onChanged(String? value) {
    setState(() {
      deskCount_selected = value!;
      deskCount = deskCount_selected;
    });
  }

  void _onChanged2(String? value) {
    setState(() {
      huniki_selected = value!;
      huniki = huniki_selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bar追加'),
        backgroundColor: Color.fromARGB(31, 70, 68, 68),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(8.8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  onChanged: (text) {
                    name = text;
                  },
                  maxLength: 21,
                  decoration: InputDecoration(
                    hintText: '店名',
                    fillColor: Color.fromARGB(255, 86, 84, 84),
                    filled: true,
                    isDense: true,
                    prefixIcon: const Icon(Icons.local_drink),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 11),
                      child: Row(
                        children: [
                          Icon(Icons.chair_alt_sharp),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            '席数',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: DropdownButtonFormField(
                        items: <String>['1~5', '6~10', '11~20', '21~30', '30~']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: deskCount,
                        onChanged: _onChanged,
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 11),
                      child: Row(
                        children: [
                          Icon(Icons.light),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            '雰囲気',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: DropdownButtonFormField(
                        items: <String>['明るい', '普通', '暗い']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: huniki,
                        onChanged: _onChanged2,
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  onChanged: (text) {
                    memo = text;
                  },
                  maxLength: 144,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: 'メモ',
                    fillColor: Color.fromARGB(255, 86, 84, 84),
                    filled: true,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 11),
                        child: Row(
                          children: [
                            Icon(Icons.star),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              '評価',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      RatingBar.builder(
                        itemSize: 35,
                        itemBuilder: (context, index) => const Icon(
                          Icons.local_bar,
                          color: Colors.yellow,
                        ),
                        onRatingUpdate: (rating) {
                          ratingCount = rating;
                        },
                        allowHalfRating: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () async {
                    getImageFromGallery();
                  },
                  onLongPress: () async {},
                  child: Container(
                      color: Colors.black12,
                      width: 300,
                      height: 200,
                      child: _image == null
                          ? Center(child: Text('タップで画像を挿入'))
                          : Image.file(_image!,fit: BoxFit.cover,)),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black12,
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                    );
                    await uploadImage();
                  
                    final newDocumentReference = BarEventsReference.doc(iosDeviceInfo).collection('BarLists').doc();
                    final cocktailEvent = BarEvent(
                      name: name,
                      deskCount: deskCount,
                      huniki: huniki,
                      memo: memo,
                      star: ratingCount,
                      sendTime: DateFormat('yyyy MM/dd')
                          .format(DateTime.now())
                          .toString(),
                      remotePath: remotePath,
                      ref1: ref1,
                      reference: newDocumentReference,
                    );
                    await newDocumentReference.set(cocktailEvent.toMap());
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('保存'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


var BarEventsReference =
    FirebaseFirestore.instance.collection('Users').withConverter<BarEvent>(
  fromFirestore: ((snapshot, _) {
    return BarEvent.fromFirestore(snapshot);
  }),
  toFirestore: ((value, _) {
    return value.toMap();
  }),
);



