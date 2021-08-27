import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:idealog/Prefs&Data/phoneSizeInfo.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/paths.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchNotFoundIllustration extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: percentWidth(70),
            constraints: BoxConstraints(maxWidth: 250.w),
            
            child: Image.asset(Paths.Search_Pic, fit: BoxFit.contain)),
          Text("Search not found", style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_23))
      ]);
  }
}

class NoIdeaYetIllustration extends StatelessWidget {

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
                width: percentWidth(77),
                constraints: BoxConstraints(maxWidth: 300.w),

                child: Image.asset(Provider.of<Paths>(context).pathToNoIdeaPic, fit: BoxFit.contain)),
                AutoSizeText("Press + to add idea",
                     style: AppFontWeight.medium,
                    textAlign: TextAlign.center,
                    maxFontSize: AppFontSize.medium,
                    minFontSize: AppFontSize.fontSize_23)
          ]),
      ),
    );
  }
}