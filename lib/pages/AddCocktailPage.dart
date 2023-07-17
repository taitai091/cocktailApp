import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:barapp/model/CocktailInfo.dart';

class AddCocktailPage extends StatefulWidget {
  const AddCocktailPage({super.key});

  @override
  State<AddCocktailPage> createState() => _AddCocktailPageState();
}

class _AddCocktailPageState extends State<AddCocktailPage> {
  List cocktailList = [];
  String text = '';
  String memo = '';
  CocktailInfo? cocktailEvent;
  var selectedIndex = -1;

  Future<void> fetchCocktail(String text) async {
    try{
      Response response = await Dio().get(
      'https://cocktail-f.com/api/v1/cocktails?word=$text&page=1&limit=30',
    );
    cocktailList = response.data['cocktails'];
    setState(() {});
    }catch(e){
      print('情報の取得に失敗');
    };
  }

  @override
  void initState() {
    super.initState();
    fetchCocktail('ジン');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カクテル追加'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                icon: const Icon(Icons.search),
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
            Container(
              height: 400,
              child: Column(
                children: [
                  Flexible(
                    child: ListView.builder(
                      itemCount: cocktailList.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> cocktail = cocktailList[index];
                        return ListTile(
                          selected: selectedIndex == index ? true : false,
                          selectedTileColor: Colors.pink.withOpacity(0.2),
                          onTap: () {
                            cocktailEvent = CocktailInfo(
                                cocktailName: cocktail['cocktail_name'],
                                cocktailBase: cocktail['base_name'],
                                alcohol: cocktail['alcohol'],
                                cocktailDesc: cocktail['cocktail_desc'],
                                cocktailTaste: cocktail['taste_name'],
                                cocktailDigest: cocktail['cocktail_digest']);
                            setState(() {
                              selectedIndex = index;
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
            SizedBox(
              height: 40,
            ),
            TextFormField(
              onChanged: (text) {
                cocktailEvent?.cocktailMemo = text;
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(cocktailEvent);
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
