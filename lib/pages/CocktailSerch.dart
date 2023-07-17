import 'dart:ffi';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:dio/dio.dart';
import 'package:barapp/model/CocktailInfo.dart';
import 'package:barapp/objectbox.g.dart';
import 'package:barapp/model/FavoCocktail.dart';
import 'package:barapp/main.dart';
import 'Dart:math';
import 'dart:math' as math;

class CocktailSerch extends StatefulWidget {
  const CocktailSerch({super.key});

  @override
  State<CocktailSerch> createState() => _CocktailSerchState();
}

class _CocktailSerchState extends State<CocktailSerch> {
  List cocktailList = [];
  List<List<Map<String, dynamic>>> recipesList = [];
  List<String> recipesString = [];
  String text = '';
  CocktailInfo? cocktailEvent;

  Box<FavoCocktail>? favoCocktailBox;
  List<FavoCocktail> favoCocktails = [];

  Future<void> initialize() async {
    favoCocktailBox = store?.box<FavoCocktail>();
    favoCocktails = favoCocktailBox?.getAll() ?? [];
    setState(() {});
  }

  Future<void> fetchCocktail(String text) async {
    try {
      Response response = await Dio().get(
        'https://cocktail-f.com/api/v1/cocktails?word=$text&page=1&limit=30',
      );
      cocktailList = response.data['cocktails'];
      setState(() {});
    } catch (e) {
      print('情報の取得に失敗');
    }
  }

  String? getCocktailName(String name) {
    final query =
        favoCocktailBox?.query(FavoCocktail_.cockName.equals(name)).build();
    final result = query?.findFirst();
    query?.close();
    return result?.cockName;
  }

  String stringifyColor() {
    var random = math.Random().nextInt(7) + 1;
    String stringifiedColor;
    switch (random) {
      case 1:
        stringifiedColor = 'pink';
        break;
      case 2:
        stringifiedColor = 'red';
        break;
      case 3:
        stringifiedColor = 'deepOrange';
        break;
      case 4:
        stringifiedColor = 'blue';
        break;
      case 5:
        stringifiedColor = 'green';
        break;
      case 6:
        stringifiedColor = 'yellow';
        break;
      case 7:
        stringifiedColor = 'deepGreen';
        break;
      case 8:
        stringifiedColor = 'deepYellow';
        break;
      default:
        stringifiedColor = 'black';
        break;
    }
    return stringifiedColor;
  }

  @override
  void initState() {
    super.initState();
    fetchCocktail('ジン');
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('カクテル検索'),
          backgroundColor: Color.fromARGB(31, 70, 68, 68),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  fillColor: Color.fromARGB(255, 86, 84, 84),
                  filled: true,
                  isDense: true,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'ジン',
                ),
                onChanged: (text) {
                  text = text;
                  fetchCocktail(text);
                },
              ),
              SizedBox(
                height: 30,
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: cocktailList.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> cocktail = cocktailList[index];
                    List<dynamic> recipes = cocktail['recipes'];
                    List<Map<String, dynamic>> parsedRecipes = recipes
                        .map((recipe) => {
                              'ingredient_name': recipe['ingredient_name'],
                            })
                        .toList();
                    recipesList.add(parsedRecipes);
                    return ListTile(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 650,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 40,left: 25,right: 25),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    cocktail['cocktail_name'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Icon(
                                                    Icons.local_drink,
                                                    color: Color(
                                                      (Random().nextDouble() *
                                                                  0xFFFFFF)
                                                              .toInt() <<
                                                          0,
                                                    ).withOpacity(1.0),
                                                    size: 22,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Text(
                                            cocktail['cocktail_name_english'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        cocktail['cocktail_digest'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      if (cocktail['base_name'] != null)
                                        Text(
                                          'Base : ${cocktail['base_name']}',
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
                                        'Alchol : ${cocktail['alcohol'].toString()}%',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Text(
                                            'Taste : ${cocktail['taste_name']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          if (cocktail['taste_name'] == '中口')
                                            const Icon(
                                              Icons.local_fire_department,
                                              color: Colors.red,
                                            )
                                          else if (cocktail['taste_name'] ==
                                              '中辛口')
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
                                          else if (cocktail['taste_name'] ==
                                              '辛口')
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Recipes： '),
                                          Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                for (int i = 0;
                                                    i < recipes.length;
                                                    i++)
                                                  Text(
                                                    cocktail['recipes'][i]
                                                        ['ingredient_name'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
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
                                        cocktail['cocktail_desc'],
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
                                              onPressed: () async {
                                                for (int i = 0;
                                                    i < recipes.length;
                                                    i++) {
                                                  recipesString.add(
                                                      cocktail['recipes'][i]
                                                          ['ingredient_name']);
                                                }
                                                final favoCocktail =
                                                    FavoCocktail(
                                                  cockName:
                                                      cocktail['cocktail_name'],
                                                  cockEng: cocktail[
                                                      'cocktail_name_english'],
                                                  cockDigest: cocktail[
                                                      'cocktail_digest'],
                                                  cockAlchol:
                                                      cocktail['alcohol']
                                                          .toString(),
                                                  cockTaste:
                                                      cocktail['taste_name'],
                                                  cockBase:
                                                      cocktail['base_name'],
                                                  cockDesc:
                                                      cocktail['cocktail_desc'],
                                                  cockStyle:
                                                      cocktail['style_name'],
                                                  listS: recipesString,
                                                  color: stringifyColor(),
                                                );
                                                if (getCocktailName(cocktail[
                                                        'cocktail_name']) !=
                                                    cocktail['cocktail_name']) {
                                                  if (favoCocktail != null) {
                                                    favoCocktailBox
                                                        ?.put(favoCocktail);
                                                    Navigator.pop(context);
                                                  } else {}
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return Center(
                                                          child:
                                                              CupertinoAlertDialog(
                                                            title: Text(
                                                                "このカクテルは登録済みです。"),
                                                            actions: <Widget>[
                                                              CupertinoDialogAction(
                                                                child:
                                                                    Text("閉じる"),
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                }
                                                setState(() {
                                                  recipesString = [];
                                                });
                                              }, //=> Navigator.pop(context),
                                              child: const Text('お気に入り')),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      title: Text(cocktail['cocktail_name']),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
