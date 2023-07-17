import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class FavoCocktail{

  FavoCocktail({
    required this.cockName,
    required this.cockEng,
    this.cockBase,
    required this.cockAlchol,
    required this.cockDesc,
    required this.cockTaste,
    required this.cockStyle,
    required this.cockDigest,
    required this.listS,
    required this.color,
  });

  int id = 0;

  String cockName;
  String cockEng;
  String? cockBase;
  String cockAlchol;
  String cockDesc;
  String cockTaste;
  String cockStyle;
  String cockDigest;
  List<String> listS;
  String color;
}