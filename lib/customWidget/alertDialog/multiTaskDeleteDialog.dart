import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'alertDialogComponents.dart';

Future<bool?> showMultiDeleteDialog({required BuildContext context, required int numberOfTasksToDelete}) async {

  return showDialog<bool>(context: context,
   builder: (context)=> AlertDialog(
    contentPadding: EdgeInsets.zero,
    elevation: 5,
    content: Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AlertDialogHeader(
            headerIconColor: LightPink,
            headerTextColor: LightPink,
            context: context,
            headerIcon: FeatherIcons.trash,
            hasCloseButton: false,
            headerText: 'Delete'),

          DottedLine(lineThickness: 3, dashColor: LightPink),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'Do you want to really want to delete ',
                    style: dosis.copyWith(fontSize: 22, color: (Prefrences.instance.isDarkMode) ?Colors.white70 :Black242424)),
                  TextSpan(
                    text: (numberOfTasksToDelete == 1)
                    ?"this task ?"
                    :"all $numberOfTasksToDelete tasks ?",
                    style: dosis.copyWith(fontSize: 22, fontWeight: FontWeight.w600, color: (Prefrences.instance.isDarkMode) ?Colors.white70 :Black242424))
                ]
              )),
          ),

          AlertDialogActionButtons(
            context: context, 
            primaryActionText: "Delete", 
            secondaryActionText: "No", 
            secondaryActionTextColor: (Prefrences.instance.isDarkMode) ?Colors.white70 :Black242424,
            primaryActionButtonColor: LightPink, 
            secondaryButtonOutlineColor: (Prefrences.instance.isDarkMode) ?Colors.white70 :Black242424, 
            actionButtonsHeight: 40, 
            actionButtonsWidth: 110)
        ],
      )
    ),
    
  ), barrierDismissible: false);
}