import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/Idea/ui/TaskManager/code/MultiSelectController.dart';
import 'package:idealog/Idea/ui/TaskManager/code/reorderListController.dart';
import 'package:idealog/SearchBar/SearchNotifier.dart';
import 'package:idealog/design/textStyles.dart';

// ignore: non_constant_identifier_names
PreferredSizeWidget TaskPageAppBar ({required String pageName, required Color pageColor, required BuildContext context}) {

    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight * 1.2),
      child: Container(
        color: pageColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            toolbarHeight: kToolbarHeight * 1.2,
            title: Text(pageName, style: dosis.copyWith(fontSize: 25, color: Colors.white)),
            automaticallyImplyLeading: false,
            actions: [
              Container(
                child: IconButton(
                  onPressed: () async { 
                    FocusScope.of(context).unfocus();
                    SearchController.instance.stopSearch();
                    Navigator.pop(context);
                    // wait for the page to close finish before stoping the state.
                    await Future.delayed(Duration(milliseconds: 200),(){
                      // Stop the states if the page was popped.
                      if (ReorderListController.instance.reOrderIsActive)
                          ReorderListController.instance.disableReordering();
                      else if (MultiSelectController.instance.state)
                          MultiSelectController.instance.stopMultiSelect();
                    });
                  },
                icon: Icon(FeatherIcons.chevronDown, size: 30, color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );

}