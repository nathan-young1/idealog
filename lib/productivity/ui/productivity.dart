import 'package:flutter/material.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/productivity/code/productivityManager.dart';
import 'package:idealog/productivity/ui/activeDays.dart';
import 'package:idealog/productivity/ui/favoriteTask.dart';
import 'package:idealog/productivity/ui/taskCompletionRate.dart';
import 'package:provider/provider.dart';

class Productivity extends StatefulWidget {
  @override
  _ProductivityState createState() => _ProductivityState();
}

class _ProductivityState extends State<Productivity> {

  @override
  Widget build(BuildContext context) {
    double completionRate = Provider.of<ProductivityManager>(context).getCompletionRate();
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 25,left: 20,right: 10,bottom: 20),
            child: Text('Productivity',
            style: Poppins.copyWith(fontSize: 30)),
          ),
          Expanded(
            child: ListView(
              children: [
                TaskCompletionRate(completionRate),
                SizedBox(height: 25),
                FavoriteTasks(),
                SizedBox(height: 25),
                ActiveDaysChart()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
