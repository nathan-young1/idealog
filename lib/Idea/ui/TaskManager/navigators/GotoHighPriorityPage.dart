import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/TaskManager/pages/highPriorityPage.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';

class GotoHighPriorityPage extends StatelessWidget {
  const GotoHighPriorityPage({
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
          MaterialPageRoute(builder: (context)=> HighPriorityTaskPage(idea: idea))
        ),
        child: Container(height: 130, width: 130,
        decoration: BoxDecoration(borderRadius: borderRadius,color: HighPriorityColor),
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
            Flexible(child: Text('High Priority Tasks',style: overpass.copyWith(fontSize: 16, color: Colors.white))),
            LinearProgressIndicator(value: 60,backgroundColor: Black242424.withOpacity(0.2),color: Colors.white,),
          ],),
        ),),
      ),
    );
  }
}