import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/design/textStyles.dart';

class TasksAppBar extends StatelessWidget {
  const TasksAppBar({Key? key, required this.pageName, required this.pageColor}) : super(key: key);
  final String pageName;
  final Color pageColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: pageColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          toolbarHeight: kToolbarHeight * 1.2,
          title: Text(pageName, style: overpass.copyWith(fontSize: 25, color: Colors.white)),
          automaticallyImplyLeading: false,
          actions: [
            Container(
              child: IconButton(onPressed: ()=> Navigator.of(context).pop(),
              icon: Icon(FeatherIcons.chevronDown, size: 30, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}