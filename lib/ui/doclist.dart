import 'dart:async';
import 'package:flutter/material.dart';

import '../model/model.dart';
import '../util/dbhelper.dart';
import './docdetail.dart';

const menuReset = "Reset Local Data";
List<String> menuOptions = const <String> [
  menuReset
];

class DocList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => DocListState();
}

class DocListState extends State<DocList>{
  DbHelper dbh = DbHelper();
  List<Doc> docs;
  int count = 0;
  DateTime cDate;

    @override
    void initState(){
      super.initState();
    }

    Future getData() async {
      final dbFuture = dbh.initializedDb();
      dbFuture.then(
      (result){
        final docsFuture = dbh.getDocs();
        docsFuture.then(
          (result){
            if(result.length >= 0){
              List<Doc> docList = List<Doc>();
              var count = result.length;
              for (int i = 0 ; i <= count - 1; i++){
                docList.add(Doc.fromObject(result[i]));
              }
              setState(() {
               if(this.docs.length > 0){
                this.docs.clear();
               }
               this.docs = docList;
               this.count = count;
              });
            }
          });
      });
    }

    void _checkDate(){
      const secs = const Duration(seconds: 10);

      new Timer.periodic(secs, (Timer t) {
        DateTime nw = DateTime.now();

        if(cDate.day != nw.day || cDate.month != nw.month ||
            cDate.year != nw.year){
          getData();
          cDate = DateTime.now();
        }
      });
    }

    void navigateToDetail(Doc doc) async{
      bool r = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => DocDetail(doc))
      );

      if(r == true){
        getData();
      }
    }

    //PAGE96

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}