import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScheduleListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 15,left: 20,right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SCHEDULE',style: TextStyle(fontSize: 27,fontWeight: FontWeight.w600)),
                IconButton(icon: FaIcon(FontAwesomeIcons.calendarAlt), onPressed: (){},iconSize: 30),
              ],
            ),
          ),
        ],
      )
    );
  }
}