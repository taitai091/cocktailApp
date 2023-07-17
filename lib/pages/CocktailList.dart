import 'package:barapp/model/BarEvent.dart';
import 'package:barapp/pages/AddBarEvent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barapp/objectbox.g.dart';
import 'package:barapp/model/FavoCocktail.dart';
import 'package:barapp/main.dart';
import 'Dart:math';
import 'package:reorderable_grid/reorderable_grid.dart';

class CocktailList extends StatefulWidget {
  const CocktailList({super.key});

  @override
  State<CocktailList> createState() => _CocktailListState();
}

class _CocktailListState extends State<CocktailList> {
  Box<FavoCocktail>? favoCocktailBox;
  List<FavoCocktail> favoCocktails = [];

  Future<void> initialize() async {
    favoCocktailBox = store?.box<FavoCocktail>();
    favoCocktails = favoCocktailBox?.getAll() ?? [];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void _onReorder(int oldIndex, int newIndex) {
    final item = favoCocktails.removeAt(oldIndex);
    favoCocktails.insert(newIndex, item);
    favoCocktailBox?.removeAll();
    for (int i = 0; i < favoCocktails.length; i++) {
      final favoCocktail = favoCocktails[i];
      final newFavoCock = FavoCocktail(
          cockName: favoCocktail.cockName,
          cockEng: favoCocktail.cockEng,
          cockBase: favoCocktail.cockBase,
          cockAlchol: favoCocktail.cockAlchol,
          cockDesc: favoCocktail.cockDesc,
          cockTaste: favoCocktail.cockTaste,
          cockStyle: favoCocktail.cockStyle,
          cockDigest: favoCocktail.cockDigest,
          listS: favoCocktail.listS,
          color: favoCocktail.color);
      favoCocktailBox?.put(newFavoCock);
    }
    initialize();
  }

  Color stringifiedColorToColor(String stringifiedColor) {
    Color reconvertedColor;
    switch (stringifiedColor) {
      case 'pink':
        reconvertedColor = Colors.pink;
        break;
      case 'red':
        reconvertedColor = Colors.red;
        break;
      case 'deepOrange':
        reconvertedColor = Colors.deepOrange;
        break;
      case 'blue':
        reconvertedColor = Colors.blue;
        break;
      case 'green':
        reconvertedColor = Colors.green;
        break;
      case 'yellow':
        reconvertedColor = Colors.yellow;
        break;
      case 'deepGreen':
        reconvertedColor = Colors.blueGrey;
        break;
      case 'deepYellow':
        reconvertedColor = Colors.purple;
        break;
      default:
        reconvertedColor = Colors.black;
        break;
    }
    return reconvertedColor;
  }

  @override
  Widget build(BuildContext context) {

    double? _deviceWidth;
    _deviceWidth = MediaQuery.of(context).size.width;
    int cross;
    if(_deviceWidth > 500){
      cross = 6;
    }else{
      cross = 3;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('カクテル'),
        backgroundColor: Color.fromARGB(31, 70, 68, 68),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              child: Row(
                children: [
                  Text(
                    'お気に入りカクテル数：${favoCocktails.length.toString()}',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: ReorderableGridView.builder(
                onReorder: _onReorder,
                itemCount: favoCocktails.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cross, mainAxisSpacing: 4, crossAxisSpacing: 4),
                itemBuilder: (context, index) {
                  final favoCocktail = favoCocktails[index];
                  return InkWell(
                    key: Key('$index'),
                    onTap: () {
                      TapMethod(context, favoCocktail);
                    },
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color.fromARGB(31, 255, 255, 255),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 18),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    if (favoCocktail.cockStyle == 'ショート')
                                      Container(
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.local_bar,
                                            size: 25,
                                            color: stringifiedColorToColor(
                                                favoCocktail.color),
                                          ),
                                          radius: 18,
                                        ),
                                      )
                                    else if (favoCocktail.cockStyle == 'ロング')
                                      Container(
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.local_drink_sharp,
                                            size: 25,
                                            color: stringifiedColorToColor(
                                                favoCocktail.color),
                                          ),
                                          radius: 18,
                                        ),
                                      ),
                                    Column(
                                      children: [
                                        if (favoCocktail.cockTaste == '中口')
                                          const Icon(
                                            Icons.local_fire_department,
                                            size: 17,
                                            color: Colors.red,
                                          )
                                        else if (favoCocktail.cockTaste ==
                                            '中辛口')
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.local_fire_department,
                                                size: 17,
                                                color: Colors.red,
                                              ),
                                              const Icon(
                                                Icons.local_fire_department,
                                                size: 17,
                                                color: Colors.red,
                                              ),
                                            ],
                                          )
                                        else if (favoCocktail.cockTaste == '辛口')
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.local_fire_department,
                                                size: 17,
                                                color: Colors.red,
                                              ),
                                              const Icon(
                                                Icons.local_fire_department,
                                                size: 17,
                                                color: Colors.red,
                                              ),
                                              const Icon(
                                                Icons.local_fire_department,
                                                size: 17,
                                                color: Colors.red,
                                              ),
                                            ],
                                          )
                                        else if (favoCocktail.cockTaste ==
                                            '中甘口')
                                          const Icon(
                                            Icons.icecream_rounded,
                                            size: 20,
                                            color: Color.fromARGB(
                                                255, 234, 144, 172),
                                          )
                                        else if (favoCocktail.cockTaste == '甘口')
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.icecream_rounded,
                                                size: 20,
                                                color: Color.fromARGB(
                                                    255, 234, 144, 172),
                                              ),
                                              const Icon(
                                                Icons.icecream_rounded,
                                                size: 20,
                                                color: Color.fromARGB(
                                                    255, 234, 144, 172),
                                              ),
                                            ],
                                          ),
                                        SizedBox(height: 5),
                                        Text(
                                          '${favoCocktail.cockAlchol} %',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 45,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 21, 28, 28),
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(12),
                                        bottomLeft: Radius.circular(12))),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Center(
                                    child: Text(
                                      favoCocktail.cockName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Future<dynamic> TapMethod(BuildContext context, FavoCocktail favoCocktail) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: 650,
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                favoCocktail.cockName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.local_drink,
                                color:
                                    stringifiedColorToColor(favoCocktail.color),
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        favoCocktail.cockEng,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    favoCocktail.cockDigest,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 15),
                  if (favoCocktail.cockBase != null)
                    Text(
                      'Base : ${favoCocktail.cockBase}',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    )
                  else
                    Text(
                      'Base : なし',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  SizedBox(height: 15),
                  Text(
                    'Alchol : ${favoCocktail.cockAlchol.toString()}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        'Taste : ${favoCocktail.cockTaste}',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(width: 10),
                      if (favoCocktail.cockTaste == '中口')
                        const Icon(
                          Icons.local_fire_department,
                          color: Colors.red,
                        )
                      else if (favoCocktail.cockTaste == '中辛口')
                        Row(
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              color: Colors.red,
                            ),
                            const Icon(
                              Icons.local_fire_department,
                              color: Colors.red,
                            ),
                          ],
                        )
                      else if (favoCocktail.cockTaste == '辛口')
                        Row(
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              color: Colors.red,
                            ),
                            const Icon(
                              Icons.local_fire_department,
                              color: Colors.red,
                            ),
                            const Icon(
                              Icons.local_fire_department,
                              color: Colors.red,
                            ),
                          ],
                        )
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Recipes： '),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < favoCocktail.listS.length; i++)
                              Text(
                                favoCocktail.listS[i],
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    favoCocktail.cockDesc,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
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
                                            onPressed: () {
                                              favoCocktailBox
                                                  ?.remove(favoCocktail.id);
                                              favoCocktails =
                                                  favoCocktailBox?.getAll() ??
                                                      [];
                                              setState(() {});
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            }),
                                      ],
                                    ),
                                  );
                                });
                          }, //=> Navigator.pop(context),
                          child: const Text('削除')),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
