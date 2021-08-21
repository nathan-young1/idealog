import 'package:flutter/material.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/paths.dart';

class NoTaskYet extends StatelessWidget {
  const NoTaskYet({Key? key}) : super(key: key);

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
                child: Image.asset(Paths.No_Tasks_Pic, fit: BoxFit.contain)),
              Text("No tasks available.", style: dosis.copyWith(fontSize: 22))
          ]),
      ),
    );
  }
}