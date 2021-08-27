import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/Prefs&Data/phoneSizeInfo.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'alertDialogComponents.dart';

Future<bool?> showAutoStartDialog({required BuildContext context}) async {

  return showDialog<bool>(context: context, builder: (context)=> AlertDialog(
    contentPadding: EdgeInsets.zero,
    elevation: 5,
    content: Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AlertDialogHeader(
            headerIconColor: (Prefrences.instance.isDarkMode) ?DarkRed :DarkBlue,
            headerTextColor: (Prefrences.instance.isDarkMode) ?DarkRed :DarkBlue,
            context: context,
            headerIcon: FeatherIcons.uploadCloud,
            hasCloseButton: true,
            headerText: "Data Backup"),

          DottedLine(lineThickness: 3, dashColor: (Prefrences.instance.isDarkMode) ?DarkRed :DarkBlue),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: AutoSizeText.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'In other to start auto-backup every 24-hours, you need to enable',
                    style: dosis.copyWith(fontSize: AppFontSize.fontSize_20, color: (Prefrences.instance.isDarkMode) ?Colors.white70 :Black242424)),
                  TextSpan(text: ' AutoStart',
                    style: dosis.copyWith(fontSize: AppFontSize.fontSize_20, fontWeight: FontWeight.w600, color: (Prefrences.instance.isDarkMode) ?Colors.white70 :Black242424)),
                  TextSpan(text: ' permission for ',
                    style: dosis.copyWith(fontSize: AppFontSize.fontSize_20, color: (Prefrences.instance.isDarkMode) ?Colors.white70 :Black242424)),
                  TextSpan(text: 'Idealog.',
                    style: dosis.copyWith(fontSize: AppFontSize.fontSize_20, fontWeight: FontWeight.w600, color: (Prefrences.instance.isDarkMode) ?Colors.white70 :Black242424))
                ]
              )),
          ),

          AlertDialogActionButtons(
            context: context,
            isAutoStartDialog: true,
            primaryActionText: "Enable", 
            secondaryActionText: "Already enabled", 
            primaryActionButtonColor: (Prefrences.instance.isDarkMode) ?DarkRed :DarkBlue, 
            secondaryButtonOutlineColor: (Prefrences.instance.isDarkMode) ?Colors.white70 :DarkBlue,
            secondaryActionTextColor: (Prefrences.instance.isDarkMode) ?Colors.white70 :DarkBlue, 
            actionButtonsHeight: 40)
      ]),
    ),
  ), barrierDismissible: false);
}