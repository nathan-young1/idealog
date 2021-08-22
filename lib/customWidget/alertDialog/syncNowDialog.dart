import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'alertDialogComponents.dart';

showSyncNowDialog({required BuildContext context}) async {
   AlertDialog alertDialog = AlertDialog(
    contentPadding: EdgeInsets.zero,
    elevation: 5,
    content: Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AlertDialogHeader(
            headerIconColor: DarkBlue,
            headerTextColor: DarkBlue,
            context: context,
            headerIcon: FeatherIcons.uploadCloud,
            hasCloseButton: false,
            headerText: "Data Backup"),

          DottedLine(lineThickness: 3, dashColor: DarkBlue),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Center(child: Text('Uploading Data', style: dosis.copyWith(fontSize: 20,fontWeight: FontWeight.w600))),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              height: 45,
              width: 45,
              child: CircularProgressIndicator(color: DarkBlue, strokeWidth: 5)),
          )

      ]),
    ),
  );

  await showDialog(context: context, builder: (context)=> alertDialog, barrierDismissible: false);
}