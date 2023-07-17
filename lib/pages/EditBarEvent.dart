import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:barapp/model/BarEvent.dart';
import 'package:barapp/pages/barListPage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:barapp/pages/AddCocktailPage.dart';
import 'package:barapp/model/CocktailInfo.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditBarEvent extends StatefulWidget {
  const EditBarEvent({super.key, required this.barEvent});

  final BarEvent barEvent;

  @override
  State<EditBarEvent> createState() => _EditBarEventState();
}

class _EditBarEventState extends State<EditBarEvent> {
  String? name;
  String? deskCount;
  String? huniki;
  String? memo;
  double? ratingCount;
  String deskCount_selected = '';
  String huniki_selected = '';
  File? _image;
  String? remotePath;
  String? ref1;
  BarEvent? barEvent;
  final picker = ImagePicker();

  void initState() {}

  Future<PickedFile?> getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Future<void> uploadImage() async {
    if (widget.barEvent.remotePath == null) {
      if (_image != null) {
        String path = _image!.path.substring(_image!.path.lastIndexOf('/') + 1);
        final ref = FirebaseStorage.instance.ref(path);
        final storageImage = await ref.putFile(_image!);
        remotePath = await storageImage.ref.getDownloadURL();
        ref1 = path;
      } else {}
    } else {}
  }

  Future<void> deleteImage() async {
    final ref = FirebaseStorage.instance.ref(widget.barEvent.ref1);
    try {
      await ref.delete();
    } catch (e) {
      print('削除不可');
    }
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

  void _UpdatebarList(String keyName, dynamic newInfo) {
    if (newInfo != null) {
      widget.barEvent.reference.update({keyName: newInfo});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('編集'),
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
                  initialValue: widget.barEvent.name,
                  onChanged: (text) {
                    name = text;
                  },
                  maxLength: 21,
                  decoration: InputDecoration(
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
                        value: widget.barEvent.deskCount,
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
                        value: widget.barEvent.huniki,
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
                  initialValue: widget.barEvent.memo,
                  onChanged: (text) {
                    memo = text;
                  },
                  maxLines: 6,
                  maxLength: 144,
                  keyboardType: TextInputType.multiline,
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
                        initialRating: widget.barEvent.star,
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
                    if (widget.barEvent.remotePath != null) {
                      await deleteImage();
                      setState(() {
                        widget.barEvent.remotePath = null;
                        _image = null;
                      });
                      getImageFromGallery();
                    } else {
                      getImageFromGallery();
                    }
                  },
                  onLongPress: () {
                    /*画像ズーム機能*/
                  },
                  child: Container(
                      color: Colors.black12,
                      width: 300,
                      height: 200,
                      child: widget.barEvent.remotePath == null
                          ? Center(
                              child: _image == null
                                  ? Text('タップで画像を挿入')
                                  : Image.file(_image!,fit: BoxFit.cover,))
                          : Image.network(
                              widget.barEvent.remotePath.toString(),
                              fit: BoxFit.cover,
                              errorBuilder: (c, o, s) {
                                return const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 30,
                                );
                              },
                            )),
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
                    if (name != null) {
                      _UpdatebarList('name', name);
                    } else if (name == null) {
                      String newName;
                      newName = widget.barEvent.name;
                      _UpdatebarList('name', newName);
                    }
                    if (deskCount != null) {
                      _UpdatebarList('deskCount', deskCount);
                    } else {
                      String newDeskCount;
                      newDeskCount = widget.barEvent.deskCount.toString();
                      _UpdatebarList('deskCount', newDeskCount);
                    }
                    if (huniki != null) {
                      _UpdatebarList('huniki', huniki);
                    } else {
                      String newHuniki;
                      newHuniki = widget.barEvent.huniki.toString();
                      _UpdatebarList('huniki', newHuniki);
                    }
                    if (memo != null) {
                      _UpdatebarList('memo', memo);
                    } else {
                      String newMemo;
                      newMemo = widget.barEvent.memo.toString();
                      _UpdatebarList('memo', newMemo);
                    }
                    if (ratingCount != null) {
                      _UpdatebarList('star', ratingCount);
                    } else {
                      double newStar;
                      newStar = widget.barEvent.star;
                      _UpdatebarList('star', newStar);
                    }
                    if (remotePath != null) {
                      _UpdatebarList('remotePath', remotePath);
                    } else {
                      if (widget.barEvent.remotePath != null) {
                        String newRemotePath;
                        newRemotePath = widget.barEvent.remotePath.toString();
                        _UpdatebarList('remotePath', newRemotePath);
                      } else {}
                    }
                    if (ref1 != null) {
                      _UpdatebarList('ref1', ref1);
                    } else {
                      if (widget.barEvent.ref1 != null) {
                        String newRef1;
                        newRef1 = widget.barEvent.ref1.toString();
                        _UpdatebarList('ref1', ref1);
                      } else {}
                    }
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
