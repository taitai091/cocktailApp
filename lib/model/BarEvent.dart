import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BarEvent{
  String name;
  String? deskCount;
  String? huniki;
  String? memo;
  double  star;
  String sendTime;
  String? remotePath;
  String? ref1;
  final DocumentReference reference;

  BarEvent({
    required this.name,
    this.deskCount,
    this.huniki,
    this.memo,
    required this.star,
    required this.sendTime,
    this.remotePath,
    this.ref1,
    required this.reference,
  });

  factory BarEvent.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!; 
    return BarEvent(
      name:map['name'], 
      deskCount: map['deskCount'],
      huniki: map['huniki'],
      memo: map['memo'],
      star: map['star'], 
      sendTime: map['sendTime'],
      remotePath: map['remotePath'],
      ref1: map['ref1'],
      reference: snapshot.reference,
      );
  }

  Map<String, dynamic> toMap(){
    return{
      'name':name,
      'deskCount':deskCount,
      'huniki':huniki,
      'memo': memo,
      'star':star,
      'sendTime':sendTime,
      'remotePath':remotePath,
      'ref1':ref1,
    };
  }

}