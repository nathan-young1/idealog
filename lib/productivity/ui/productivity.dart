import 'package:flutter/material.dart';
import 'package:idealog/Databases/analytics-db/analyticsSql.dart';
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
    var completionRate = Provider.of<ProductivityManager>(context).getCompletionRate();
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 25,left: 20,right: 10),
          child: Text('Productivity',
          style: dosis.copyWith(fontSize: 30)),
        ),
        Expanded(
          child: ListView(
            children: [
              TaskCompletionRate(completionRate),
              SizedBox(height: 10),
              FavoriteTasks(),
              SizedBox(height: 10),
              ActiveDaysChart()
            ],
          ),
        ),
      ],
    );
  }
}
