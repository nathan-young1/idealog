import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/Idea/ui/TaskManager/pages/uncompletedTasksPage.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';

class GotoUncompletedPage extends StatelessWidget {
  const GotoUncompletedPage({
    Key? key,
    required this.borderRadius,
  }) : super(key: key);

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {

    return Consumer<Idea>(
      builder: (context, Idea idea,_) =>
      GestureDetector(
        onTap: () => 
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=> UncompletedTasksPage(idea: idea))
        ),
        child: Container(height: 130, width: 130,
        decoration: BoxDecoration(borderRadius: borderRadius,color: uncompletedTasksColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Black242424.withOpacity(0.2)),
              child: Icon(FeatherIcons.list,color: Colors.white,size: 18)
            ),
            Flexible(child: Text('Uncompleted Tasks',style: overpass.copyWith(fontSize: 16, color: Colors.white))),
            LinearProgressIndicator(value: 60,backgroundColor: Black242424.withOpacity(0.2),color: Colors.white,),
          ],),
        ),),
      ),
    );
  }
}