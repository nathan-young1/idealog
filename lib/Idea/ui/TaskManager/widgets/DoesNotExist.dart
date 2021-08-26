import 'package:flutter/material.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/paths.dart';
import 'package:provider/provider.dart';

class SearchNotFoundIllustration extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 230,
            width: 250,
            child: Image.asset(Paths.Search_Pic, fit: BoxFit.contain)),
          Text("Search not found", style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_23))
      ]);
  }
}

class IdeaDoesNotExistIllustration extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment(0, -0.3),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 300,
                width: 300,
                child: Image.asset(Provider.of<Paths>(context).pathToNoIdeaPic, fit: BoxFit.contain)),
              Text("Press + to add idea", style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_23))
          ]),
      ),
    );
  }
}