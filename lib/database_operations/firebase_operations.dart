import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gelirgidertakip/pages/main_page.dart';
import 'package:intl/intl.dart';

class AddStatus {
  StatusService statusSevice = StatusService();
}

class StatusList {  //Veritabanına kayıt edilen kullanıcı verilerinin türleri  //Types of user data saved in the database
  late final String id;
  late final double income;
  late final double expense;
  late final DateTime date;
  late final String category;
  late final String month;
  late final String year;
  late final String type;
  late final String note;

  StatusList({
    required this.id,
    required this.income,
    required this.expense,
    required this.date,
    required this.category,
    required this.month,
    required this.year,
    required this.type,
    required this.note,
  });

  factory StatusList.fromSnapshot(DocumentSnapshot snapshot) {
    return StatusList(
      id: snapshot.id,
      income: snapshot['gelir'],
      expense: snapshot['gider'],
      date: snapshot['tarih'],
      category: snapshot['kategori'],
      month: snapshot['ay'],
      year: snapshot['yıl'],
      type: snapshot['tip'],
      note: snapshot['not'],
    );
  }
}

class StatusService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;


  Future addData(
      double income, double expense, DateTime date, String category, String month, String year, String type, String note) async {
    var ref = _firestore.collection('records');

    var documentRef = await ref.add({
      'email': auth.currentUser?.email,
      'gelir': income,
      'gider': expense,
      'tarih': date,
      'kategori': category,
      'ay': month,
      'yıl': year,
      'tip': type,
      'not': note,
    });

    return StatusList(
      id: documentRef.id,
      income: income,
      expense: expense,
      date: date,
      category: category,
      month: month,
      year: year,
      type: type,
      note: note,
    );
  }

  Stream<QuerySnapshot>? getTotalView() {  //Genel istatistik verisinin veritabanından dinlenmesi  //Listening of general statistics data from database
    Stream<QuerySnapshot<Map<String, dynamic>>> ref = FirebaseFirestore.instance
        .collection('records')
        .where('email', isEqualTo: auth.currentUser?.email)
        .snapshots();

    return ref;
  }

  Stream<QuerySnapshot>? getUserView() {  //Kaydedilen gelir-gider detaylarının veritabanından dinlenmesi  //Listening of the recorded income-expense details from the database
    Stream<QuerySnapshot<Map<String, dynamic>>> ref = FirebaseFirestore.instance
        .collection('records')
        .where('email', isEqualTo: auth.currentUser?.email)
        .snapshots();

    return ref;
  }

  Stream<QuerySnapshot>? getInExView() {  //Kaydedilen gelir-gider verilerinin veritabanından dinlenmesi  //Listening to the recorded income-expense data from the database
    Stream<QuerySnapshot<Map<String, dynamic>>> ref = FirebaseFirestore.instance
        .collection('records')
        .where('email', isEqualTo: auth.currentUser?.email)
        .orderBy('tarih', descending: true)
        .snapshots();
    return ref;
  }

  // Verilerin silinmesi
  // Deletion of data
  Future removeStatus(String docId) {
    var ref = _firestore.collection('records').doc(docId).delete();

    return ref;
  }
}