import 'package:flutter/material.dart';

class CocktailInfo{

  String cocktailName;
  String? cocktailMemo;
  String? cocktailBase;
  int? alcohol;
  String? cocktailDesc;
  String? cocktailTaste;
  String? cocktailDigest;

  CocktailInfo({
    required this.cocktailName,
    this.cocktailMemo,
    this.cocktailBase,
    this.alcohol,
    this.cocktailDesc,
    this.cocktailTaste,
    this.cocktailDigest,
  });
  
}