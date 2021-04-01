import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/global/enums.dart';
import 'package:idealog/idea/code/ideaManager.dart';
import 'package:idealog/sqlite-db/sqlite.dart';

class IdeaListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.only(top: 15,left: 20,right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('IDEAS',style: TextStyle(fontSize: 27,fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    IconButton(icon: Icon(Icons.search_sharp), onPressed: (){},iconSize: 30),
                    IconButton(icon: Icon(Icons.filter_list), onPressed: (){},iconSize: 30)
                  ],
                )
              ],
            ),
          ),
          FutureBuilder<List<Idea>>(
            future: getListOfIdeas(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                return Expanded(
                      child: ListView(
                        children: snapshot.data!.map((e) => Text(e.ideaTitle)).toList(),
                      ),
                    );
              }
              return Expanded(child: Center(child: CircularProgressIndicator()));
            }
          )
        ],
      ),
    );
  }
}