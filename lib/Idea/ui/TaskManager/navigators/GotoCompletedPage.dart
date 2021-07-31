import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/TaskManager/pages/completedTasksPage.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';

class GotoCompletedPage extends StatelessWidget {
  const GotoCompletedPage({
    Key? key,
    required this.borderRadius,
  }) : super(key: key);

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Consumer<Idea>(
      builder: (context, Idea idea,_) => 
      GestureDetector(
        onTap: ()=>
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=> CompletedTasksPage(idea: idea))
        ),
        child: Container(height: 130, width: 130,
        decoration: BoxDecoration(borderRadius: borderRadius,color: completedTasksColor),
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
              child: Icon(Icons.warning_amber_outlined,color: Colors.white,size: 18)
            ),
            Flexible(child: Text('Completed Tasks',style: overpass.copyWith(fontSize: 16, color: Colors.white))),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Text('20/20',style: overpass.copyWith(fontSize: 14,color: Colors.white),)],)
          ],),
        ),),
      ),
    );
  }
}