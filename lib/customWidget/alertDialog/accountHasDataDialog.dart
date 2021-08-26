import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'alertDialogComponents.dart';

showAccountHasDataDialog({required BuildContext context, required String email}) async {
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
            headerIconColor: (Prefrences.instance.isDarkMode) ?DarkRed :DarkBlue,
            headerTextColor: (Prefrences.instance.isDarkMode) ?DarkRed :DarkBlue,
            context: context,
            headerIcon: FeatherIcons.uploadCloud,
            hasCloseButton: false,
            headerText: "Data Backup"),

          DottedLine(lineThickness: 3, dashColor: (Prefrences.instance.isDarkMode) ?DarkRed :DarkBlue),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'You have some',
                    style: dosis.copyWith(fontSize: 22, color: (Prefrences.instance.isDarkMode) ?Colors.white70 :Black242424)),
                  TextSpan(text: ' Ideas',
                    style: dosis.copyWith(fontSize: 22, fontWeight: FontWeight.w600, color: (Prefrences.instance.isDarkMode) ?Colors.white70 :Black242424)),
                  TextSpan(text: ' stored in ',
                    style: dosis.copyWith(fontSize: 22, color: (Prefrences.instance.isDarkMode) ?Colors.white70 :Black242424)),
                  TextSpan(text: '$email,',
                    style: dosis.copyWith(fontSize: 22, fontWeight: FontWeight.w600, color: (Prefrences.instance.isDarkMode) ?Colors.white70 :Black242424)),
                  TextSpan(text: ' what do you want to do?',
                    style: dosis.copyWith(fontSize: 22, color: (Prefrences.instance.isDarkMode) ?Colors.white70 :Black242424)),
                ]
              )),
          ),

          AlertDialogActionButtons(
            context: context,
            primaryActionText: "Download", 
            secondaryActionText: "Ignore", 
            secondaryActionTextColor: (Prefrences.instance.isDarkMode) ?Colors.white70 :LightPink,
            primaryActionButtonColor: (Prefrences.instance.isDarkMode) ?DarkRed :DarkBlue, 
            secondaryButtonOutlineColor: (Prefrences.instance.isDarkMode) ?Colors.white70 :LightPink, 
            actionButtonsHeight: 40, 
            actionButtonsWidth: 110)
      ]),
    ),
  );

  await showDialog(context: context, builder: (context)=> alertDialog, barrierDismissible: false);
}