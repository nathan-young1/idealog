import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/animatedListTile.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/paths.dart';

class NoTaskYet extends StatelessWidget {
  const NoTaskYet({Key? key, required this.page}) : super(key: key);
  final TaskPage page;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment(0, -0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 230,
                width: 250,
                child: Image.asset(
                  (page == TaskPage.COMPLETED)
                  ?Paths.No_Tasks_Pic_CompletedPage
                  :(page == TaskPage.UNCOMPLETED)
                    ?Paths.No_Tasks_Pic_UncompletedPage
                    :Paths.No_Tasks_Pic_HighPriorityPage, fit: BoxFit.contain)),
              Text(
                (page == TaskPage.COMPLETED)
                ?"No completed tasks available"
                :"No tasks available.", style: dosis.copyWith(fontSize: 22))
          ]),
      ),
    );
  }
}